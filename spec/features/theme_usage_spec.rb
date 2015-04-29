require 'rails_helper'

describe "theme usage" do
  context "as regular user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    before :each do
      log_in_as user
      @other_theme = FactoryGirl.create(:theme, user: other_user)
    end

    it "should allow viewing own and others themes" do
      user_theme = FactoryGirl.create(:theme, user: user)
      visit(themes_path)
      expect(find('table')).to have_content user_theme.name
      expect(find('table')).to have_content @other_theme.name
    end

    it "should disallow actions on others themes" do
      visit(themes_path)
      expect(page).to have_xpath(".//table/tbody/tr", :count => 1)
      expect(find('table')).to have_content @other_theme.name
      expect(find('table')).not_to have_content I18n.t('helpers.links.edit')
      expect(find('table')).not_to have_content I18n.t('helpers.links.destroy')

      visit(edit_theme_path(@other_theme))
      expect(current_path).to eq(logged_in_home_path)
      expect(page).to have_content(I18n.t('controllers.auth.not_authorized'))
    end

    it "should let you create a slideshow with a theme" do
      yet_another_theme = FactoryGirl.create(:theme, user: other_user)
      visit(themes_path)
      page.find('tr', text: yet_another_theme.name).click_link I18n.t('controllers.themes.use_this_theme')
      expect(current_path).to eq(new_theme_slideshow_path(yet_another_theme))
      expect(find_field('Theme').value).to eq(yet_another_theme.id.to_s)
    end

    it "should allow editing a theme" do
      log_in_as(other_user)
      visit(edit_theme_path(@other_theme))
      desc = Faker::Hacker.say_something_smart
      fill_in('Description', with: desc)
      click_button('Update Theme')
      expect(current_path).to eq(theme_path(@other_theme))
      expect(page).to have_content(desc)
    end

    it "should allow creating a theme" do
      log_in_as(other_user)
      visit(new_theme_path)
      desc = Faker::Hacker.say_something_smart
      fill_in('Description', with: desc)
      fill_in('Name', with: Faker::Commerce.product_name)
      click_button('Create Theme')
      expect(page).to have_content(desc)
      expect(page).to have_content("success")
    end


  end
end
