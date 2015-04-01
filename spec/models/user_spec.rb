require 'rails_helper'

RSpec.describe User do
  describe "initialization" do
    let(:user) { User.new }

    it 'creates a new user with a minimum set of attributes' do
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :password, :provider, :uid])

      user.provider = 'identity'
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :password, :uid])

      user.provider = 'google_oauth2' # should get rid of password error also
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :uid])

      user.email = user.uid = 'aocole@oui.st'
      user.role = User.roles['user']
      expect(user.save).to be_truthy
    end
  end

end
