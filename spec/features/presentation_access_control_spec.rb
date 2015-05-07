require 'rails_helper'

describe "slideshow access control" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    it "should allow viewing own slideshows" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      other_slideshow = FactoryGirl.create(:slideshow, user: other_user)
      visit_expect(presentations_path)
      expect(find('table')).to have_content user_slideshow.name
      expect(find('table')).not_to have_content other_slideshow.name
    end

    it "should allow editing own slideshows" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      visit_expect(presentations_path)
      click_link_or_button("Edit")
      expect(current_path).to eq edit_slideshow_path(user_slideshow)
      expect(find_field('Name').value).to eq user_slideshow.name
      fill_in('Name', with: Faker::Commerce.product_name)
      click_button 'Save'
      expect(current_path).to eq(presentation_path(user_slideshow))
    end
    
    it "should allow deleting own foldershows" do
      log_in_as user
      FactoryGirl.create(:slideshow, user: user)
      visit_expect(presentations_path)
      expect(page).to have_xpath(".//table/tbody/tr", :count => 1)
      click_link_or_button('Delete')
      expect(current_path).to eq presentations_path
      expect(page).not_to have_xpath(".//table/tbody/tr")
    end
    
    it "should show own slideshows" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      visit_expect(presentations_path)
      click_link(user_slideshow.name)
      expect(current_path).to eq(presentation_path(user_slideshow))
      expect(page).to have_content(user_slideshow.name)
    end

    it "should go back from show slideshow" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      visit_expect(presentation_path(user_slideshow))
      click_link_or_button('Back')
      expect(current_path).to eq(presentations_path)
    end
    
    it "should delete from show slideshow" do
      log_in_as user
      user_slideshow = FactoryGirl.create(:slideshow, user: user)
      visit_expect(presentation_path(user_slideshow))
      click_link_or_button('Delete')
      expect(current_path).to eq(presentations_path)
      expect(page).not_to have_content(user_slideshow.name)
    end
    
    it "should allow creating slideshows" do
      log_in_as user
      theme = FactoryGirl.create(:theme)
      visit_expect(new_slideshow_path)
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

describe "foldershow access control" do
  describe "as regular user" do

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    it "should allow viewing own foldershows" do
      log_in_as user
      user_foldershow = FactoryGirl.create(:foldershow, user: user)
      other_foldershow = FactoryGirl.create(:foldershow, user: other_user)
      visit_expect(presentations_path)
      expect(find('table')).to have_content user_foldershow.name
      expect(find('table')).not_to have_content other_foldershow.name
    end

    it "should allow editing own foldershows" do
      log_in_as user
      user_foldershow = FactoryGirl.create(:foldershow, user: user)
      visit_expect(edit_foldershow_path(user_foldershow))
      expect(find_field('Name').value).to eq user_foldershow.name
      fill_in('Name', with: Faker::Commerce.product_name)
      click_button 'Save'
    end
    
    it "should allow deleting own foldershows" do
      log_in_as user
      FactoryGirl.create(:foldershow, user: user)
      visit_expect(presentations_path)
      expect(page).to have_xpath(".//table/tbody/tr", :count => 1)
      click_link_or_button('Delete')
      expect(current_path).to eq presentations_path
      expect(page).not_to have_xpath(".//table/tbody/tr")
    end
    
    it "should show own foldershows" do
      log_in_as user
      user_foldershow = FactoryGirl.create(:foldershow, user: user)
      visit_expect(presentations_path)
      click_link(user_foldershow.name)
      expect(current_path).to eq(presentation_path(user_foldershow))
      expect(page).to have_content(user_foldershow.name)
    end

    it "should go back from show foldershow" do
      log_in_as user
      user_foldershow = FactoryGirl.create(:foldershow, user: user)
      visit_expect(presentation_path(user_foldershow))
      click_link_or_button('Back')
      expect(current_path).to eq(presentations_path)
    end
    
    it "should delete from show foldershow" do
      log_in_as user
      user_foldershow = FactoryGirl.create(:foldershow, user: user)
      visit_expect(presentation_path(user_foldershow))
      click_link_or_button('Delete')
      expect(current_path).to eq(presentations_path)
      expect(page).not_to have_content(user_foldershow.name)
    end
    
    it "should allow creating foldershows" do
      log_in_as user
      visit_expect(new_foldershow_path)
      name = Faker::Commerce.product_name
      fill_in('Name', with: name)
      attach_file('Folder zip', Rails.root.join('seed/folder_zips/hello_world.zip'))
      click_button 'Save'
      expect(current_path).to eq presentations_path
      expect(find('table')).to have_content name
    end
    
    it "should disallow actions on others foldershows" do
      log_in_as user
      other_foldershow = FactoryGirl.create(:foldershow, user: other_user)
      visit(edit_foldershow_path(other_foldershow))
      expect(current_path).to eq(not_found_path)
    end
  end
end
