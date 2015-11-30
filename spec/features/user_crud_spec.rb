require 'rails_helper'

describe "admin presentations" do
  context "as admin user" do
    let(:admin) { FactoryGirl.create(:user, role: User.roles[:admin]) }

    before :each do
      log_in_as admin
    end

    it "should have Users index" do
      other_user = FactoryGirl.create(:user, last_sign_in_at: nil)
      visit_expect logged_in_home_path
      expect(page).to have_link "Users"
      click_link "Users"

      expect(current_path).to eq users_path
      expect(page).to have_content admin.email
      expect(page).to have_content other_user.email
      expect(page).to have_content "never"
    end

    it "should create new user" do
      visit_expect users_path
      click_link_or_button "New"

      expect(current_path).to eq new_user_path

      click_link_or_button("Save")

      expect(current_path).to eq users_path
      expect(page).to have_content "prohibited this user from being saved"


      fill_in "Email", with: "alice@example.com"
      fill_in "New password", with: 'xyzzyzzy'
      fill_in "New password confirmation", with: 'xyzzyzzy'

      click_link_or_button("Save")

      expect(current_path).to eq users_path
      expect(page).to have_content "successfully created"
    end

    it "should delete user" do
      other_user = FactoryGirl.create(:user, last_sign_in_at: nil)
      visit_expect users_path
      expect(page).to have_content other_user.email
      click_link_or_button 'Delete'
      expect(current_path).to eq users_path
      expect(page).to have_content "destroyed"
    end
  end

  context "as regular user" do
    let(:user) { FactoryGirl.create(:user, role: User.roles[:user]) }

    before :each do
      log_in_as user
    end

    it "should not have Users index" do
      visit_expect logged_in_home_path
      expect(page).not_to have_link "Users"

      visit users_path
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_content "not authorized"

      visit new_user_path
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_content "not authorized"
    end
  end
end
