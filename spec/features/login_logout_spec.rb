require 'rails_helper'

describe "user login and logout" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }

    it "allows a logged-in user to view the presentations index page" do
      log_in_as(user)
      visit(presentations_path)
      expect(current_path).to eq(presentations_path)
      expect(find(".navbar")).to have_content user.email
    end  

    it "logs out a logged-in user" do
      log_in_as(user)
      expect(current_path).to eq(logged_in_home_path)
      click_link(I18n.t('nav.logout'))
      expect(current_path).to eq(new_user_session_path)
      expect(find(".navbar")).not_to have_content user.email
    end  

    it "prevents a non-logged-in user from viewing the presentations index page" do
      not_logged_in
      visit(presentations_path)
      expect(current_path).to eq(new_user_session_path)
      expect(find(".navbar")).not_to have_content user.email
    end

    it "has simple nav bar when logged out" do
      not_logged_in
      visit(logged_out_home_path)
      navbar = find(".navbar")
      expect(navbar).to have_content I18n.t('product_name')
      expect(navbar).to have_content I18n.t('nav.login')
      expect(navbar).not_to have_content Theme.model_name.human.pluralize
    end
  end

  describe "as admin user" do
    let(:user) { FactoryGirl.create(:user, :role => User.roles[:admin]) }

    it "allows a logged-in user to view the presentations index page" do
      log_in_as(user)
      visit(presentations_path)
      expect(current_path).to eq(presentations_path)
      expect(find(".navbar")).to have_content user.email
    end  

    it "logs out a logged-in user" do
      log_in_as(user)
      expect(current_path).to eq(logged_in_home_path)
      click_link(I18n.t('nav.logout'))
      expect(current_path).to eq(new_user_session_path)
      expect(find(".navbar")).not_to have_content user.email
    end  

    it "prevents a non-logged-in user from viewing the presentations index page" do
      not_logged_in
      visit(presentations_path)
      expect(current_path).to eq(new_user_session_path)
      expect(find(".navbar")).not_to have_content user.email
    end  
  end

end
