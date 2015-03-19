require 'rails_helper'

RSpec.describe User do
  describe "initialization" do
    let(:user) { User.new }

    it 'creates a new user with a minimum set of attributes' do
      expect(user.save).to be_falsy
      expect(user.errors[:email]).to be_truthy
      expect(user.errors[:uid]).to be_truthy
      expect(user.errors[:provider]).to be_truthy
      expect(user.errors[:role]).to be_truthy

      user.email = user.uid = 'aocole@oui.st'
      user.provider = 'google_oauth2'
      user.role = User.roles['user']
      expect(user.save).to be_truthy
    end
  end

end
