require 'rails_helper'
describe "User settings" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, role: User.roles[:admin]) }
  let(:password_user) { FactoryGirl.create(:user, 
    provider: "devise", 
    encrypted_password: "$2a$10$.UHXN1Vof1iINxA9LIXxOOFFDYr5E.xkoOPNDO2zDMG3LNDTgQb.G" # "foo"
  )}

  context "as regular user" do
    before :each do
      log_in_as user
    end

    it "should have working fields" do
      FactoryGirl.create_list(:slideshow, 4, user: user)
      visit_expect(logged_in_home_path)
      click_link "Settings"
      expect(current_path).to eq settings_path
      fill_in('Given name', with: 'Bob')
      fill_in('Family name', with: 'Loblaw')
      select(user.presentations[2].name, from: 'Primary presentation')
      click_link_or_button 'Save'
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_xpath '//div[contains(@class,"alert-success")]'
      visit_expect settings_path
      expect(page).to have_field('Given name', with: "Bob")
      expect(page).to have_field('Family name', with: "Loblaw")
      expect(page).to have_select('Primary presentation', selected: user.presentations[2].name)
    end

    it "Should only show certain fields" do
      visit_expect settings_path
      expect(page).to have_field('Given name', with: user.given_name)
      expect(page).to have_field('Family name', with: user.family_name)
      expect(page).to have_select('Primary presentation')
      expect(page).to have_text(user.card_number)
      expect(page).not_to have_text('New password')
      expect(page).not_to have_field('user[role]')
      expect(page).not_to have_field('user[card_number]')
      expect(page).not_to have_field('user[custom_disk_quota_mb]')
      expect(page).not_to have_text('Role')
      expect(page).not_to have_text('Quota')
    end

    it "should change password" do
      log_in_as password_user
      visit_expect settings_path
      click_link_or_button 'Change Password'
      fill_in('New password', with: 'password123')
      fill_in('New password confirmation', with: 'password123')
      click_link_or_button 'Save'
      expect(current_path).to eq '/users/sign_in'
      expect(password_user.reload.valid_password?('password123')).to be_truthy
    end

    it "shouldn't change password if empty, too short, or doesn't match" do
      log_in_as password_user

      # left blank
      visit_expect password_user_path(password_user)
      click_link_or_button 'Save'
      expect(current_path).to eq password_update_user_path(password_user)
      expect(page).to have_text "can't be blank"
      expect(password_user.reload.valid_password?("foo")).to be_truthy

      # too short
      visit_expect password_user_path(password_user)
      fill_in('New password', with: 'pass')
      fill_in('New password confirmation', with: 'pass')
      click_link_or_button 'Save'
      expect(current_path).to eq password_update_user_path(password_user)
      expect(page).to have_text "too short"
      expect(password_user.reload.valid_password?("foo")).to be_truthy

      # left blank
      visit_expect password_user_path(password_user)
      fill_in('New password', with: 'something')
      fill_in('New password confirmation', with: 'different')
      click_link_or_button 'Save'
      expect(current_path).to eq password_update_user_path(password_user)
      expect(page).to have_text "doesn't match"
      expect(password_user.reload.valid_password?("foo")).to be_truthy
    end

    it "shouldn't change other user's password" do
      log_in_as admin
      visit password_user_path(password_user)
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_text "You are not authorized"
    end
  end

  context "as admin" do
    it "should have working fields", js: true do without_vcr do
      log_in_as admin
      visit_expect(logged_in_home_path)
      click_link admin.email # open the drop down
      click_link "Settings"
      expect(current_path).to eq settings_path
 
      expect(page).to have_field('Given name', with: admin.given_name)
      expect(page).to have_field('Family name', with: admin.family_name)
      expect(page).to have_field('Card number', with: admin.card_number)
      expect(page).not_to have_field('user[role]')
      expect(page).to have_checked_field('Use default')
      expect(find('input#user_custom_disk_quota_mb')).to be_disabled
      expect(page).not_to have_text('Role')
      expect(page).to have_text('Quota')
 
      fill_in('Given name', with: 'Bob')
      fill_in('Family name', with: 'Loblaw')
      choose('Custom')
      fill_in('user_custom_disk_quota_mb', with: 1337)
      fill_in('Card number', with: 7331)


      click_link_or_button 'Save'
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_xpath '//div[contains(@class,"alert-success")]'
      visit_expect settings_path
      expect(page).to have_field('Given name', with: "Bob")
      expect(page).to have_field('Family name', with: "Loblaw")
      expect(page).to have_field('Card number', with: 7331)
      expect(page).to have_checked_field('Custom')
      expect(page).to have_field('user_custom_disk_quota_mb', with: 1337)

      choose('Use default')
      click_link_or_button 'Save'
      visit_expect settings_path
      expect(page).to have_checked_field('Use default')

    end end
  end

end
