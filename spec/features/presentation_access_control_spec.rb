require 'rails_helper'

describe "presentation access control" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    it "should allow viewing own presentations" do
      log_in_as user
      user_presentation = FactoryGirl.create(:presentation, user: user)
      other_presentation = FactoryGirl.create(:presentation, user: other_user)
      visit(presentations_path)
      expect(find('table')).to have_content user_presentation.name
      expect(find('table')).not_to have_content other_presentation.name
    end
    it "should disallow actions on others presentations" do
      log_in_as user
      other_presentation = FactoryGirl.create(:presentation, user: other_user)
      visit(edit_presentation_path(other_presentation))
      expect(current_path).to eq(not_found_path)
    end
  end
end
