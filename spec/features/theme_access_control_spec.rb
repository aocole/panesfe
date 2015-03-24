require 'rails_helper'

describe "theme access control" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    it "should allow viewing own and others themes" do
      log_in_as user
      user_theme = FactoryGirl.create(:theme, user: user)
      other_theme = FactoryGirl.create(:theme, user: other_user)
      visit(themes_path)
      expect(find('table')).to have_content user_theme.name
      expect(find('table')).to have_content other_theme.name
    end
    it "should disallow actions on others themes" do
      log_in_as user
      other_theme = FactoryGirl.create(:theme, user: other_user)
      visit(themes_path)
      expect(page).to have_xpath(".//table/tbody/tr", :count => 1)
      expect(find('table')).to have_content other_theme.name
      expect(find('table')).not_to have_content I18n.t('helpers.links.edit')
      expect(find('table')).not_to have_content I18n.t('helpers.links.destroy')

      visit(edit_theme_path(other_theme))
      expect(current_path).to eq(logged_in_home_path)
      expect(page).to have_content(I18n.t('controllers.auth.not_authorized'))
    end
  end
end
