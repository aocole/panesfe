require 'rails_helper'
describe "User settings" do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, role: User.roles[:admin]) }

  context "as regular user" do
    before :each do
      log_in_as user
    end

    it "should have working name fields" do
      visit_expect(logged_in_home_path)
      click_link "Settings"
      expect(current_path).to eq settings_path
      fill_in('Given name', with: 'Bob')
      fill_in('Family name', with: 'Loblaw')
      click_link_or_button 'Save'
      expect(current_path).to eq logged_in_home_path
      expect(page).to have_xpath '//div[contains(@class,"alert-success")]'
      visit_expect settings_path
      expect(page).to have_field('Given name', with: "Bob")
      expect(page).to have_field('Family name', with: "Loblaw")
    end

    it "Should only show certain fields" do
      visit_expect settings_path
      expect(page).to have_field('Given name', with: user.given_name)
      expect(page).to have_field('Family name', with: user.family_name)
      expect(page).to have_text(user.card_number)
      expect(page).not_to have_field('user[role]')
      expect(page).not_to have_field('user[card_number]')
      expect(page).not_to have_field('user[custom_disk_quota_mb]')
      expect(page).not_to have_text('Role')
      expect(page).not_to have_text('Quota')
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
