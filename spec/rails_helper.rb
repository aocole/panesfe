# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{User::UPLOAD_BASE}/[^.]*"])
    end
  end
end

require 'support/database_cleaner'

def log_in_as(user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[user.provider.intern] = OmniAuth::AuthHash.new({
    provider: user.provider.to_s,
    uid: user.uid,
    info: {
      given_name: user.given_name,
      family_name: user.family_name,
      email: user.email,
    }
  })
  visit user_omniauth_authorize_path(user.provider.intern)
end

def not_logged_in
  OmniAuth.config.test_mode = false
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

# By default, capybara will ignore all hidden fields. This is a smart default
# except in rare cases. For example, our AS3 file uploader requires you to
# click a hidden file field - and that makes perfect sense. In those rare
# cases, you can use this helper to override the default and force capybara
# to include hidden fields.
#
# Examples
#
#   include_hidden_fields do
#     attach_file("hidden-input", "path/to/fixture/file")
#   end
#
def include_hidden_fields
  Capybara.ignore_hidden_elements = false
  yield
  Capybara.ignore_hidden_elements = true
end

def without_vcr
  WebMock.allow_net_connect!
  VCR.turned_off { yield }
  WebMock.disable_net_connect!
end

# Visit a url and then expect that to be where you are. 
# I feel like this should be built-in to capybara.
def visit_expect(url)
    visit url
    expect(current_path).to eq url
end

Capybara.javascript_driver = :poltergeist
