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
  end
end
