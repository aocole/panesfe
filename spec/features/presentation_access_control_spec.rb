require 'rails_helper'

describe "slideshow access control" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    it "should allow viewing own slideshows" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      other_slideshow = FactoryGirl.create(:slideshow, user: other_user)
      visit(presentations_path)
      expect(find('table')).to have_content user_slideshow.name
      expect(find('table')).not_to have_content other_slideshow.name
    end

    it "should allow editing own slideshows" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      visit(edit_slideshow_path(user_slideshow))
      expect(current_path).to eq(edit_slideshow_path(user_slideshow))
      expect(find_field('Name').value).to eq user_slideshow.name
    end
    
    it "should allow creating slideshows" do
      log_in_as user
      theme = FactoryGirl.create(:theme)
      visit(new_slideshow_path)
      expect(page).to have_select('Theme', options: [theme.name])
      name = Faker::Commerce.product_name
      fill_in('Name', with: name)
      select(theme.name, from: 'Theme')
      click_button 'Save'
      expect(current_path).to match(/slideshows\/\d+\/edit/)
      expect(find_field('Name').value).to eq name
    end
    
    it "should disallow actions on others slideshows" do
      log_in_as user
      other_slideshow = FactoryGirl.create(:slideshow, user: other_user)
      visit(edit_slideshow_path(other_slideshow))
      expect(current_path).to eq(not_found_path)
    end
  end
end
