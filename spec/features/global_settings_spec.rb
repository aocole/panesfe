require 'rails_helper'

describe "global settings" do
  context "as admin user" do

    let(:user) { FactoryGirl.create(:user, role: User.roles[:admin]) }

    before :each do
      log_in_as user
      GrowingPanes.config[:test_interactive_mode] = true
    end

    after :each do
      GrowingPanes.config[:test_interactive_mode] = false
    end

    it "should detect disconnected panesd server on status" do

      allow(Panesd).to receive(:status).and_raise(Errno::ECONNREFUSED)
      expect{visit logged_in_home_path}.not_to raise_error
      expect{visit global_settings_path}.not_to raise_error
      
    end

  end

  context "as regular user" do

    let(:user) { FactoryGirl.create(:user, role: User.roles[:user]) }

    it "should not access global settings" do
      log_in_as user
      visit global_settings_path
      expect(page).to have_content(I18n.t('controllers.auth.not_authorized'))
    end

  end
end
