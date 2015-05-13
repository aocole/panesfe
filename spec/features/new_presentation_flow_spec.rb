require 'rails_helper'

describe "new presentation flow" do

  let(:user) { FactoryGirl.create(:user) }

  it "should give option to create slideshow or foldershow" do
    log_in_as user
    visit_expect logged_in_home_path
    expect(page).to have_content "Create New Slideshow"
    expect(page).to have_content "Create New Foldershow"
  end


  it "should create new custom html presentation" do
    log_in_as user
    visit_expect new_foldershow_path
    fill_in('Name', with: Faker::Commerce.product_name)
    attach_file('Folder zip', Rails.root.join('seed/folder_zips/hello_world.zip'))
    click_button "Save"
    expect(page).to have_content "success"
  end

  it "should give sane errors for new custom html presentation" do
    log_in_as user
    visit_expect new_foldershow_path
    fill_in('Name', with: Faker::Commerce.product_name)
    attach_file('Folder zip', Rails.root.join('seed/images/cast-of-growing-pains.jpg'))
    click_button "Save"
    expect(current_path).to eq foldershows_path
    expect(page).to have_content "error"
    expect(page).to have_content 'cannot be a "jpg" file. Allowed file extensions: zip'
    expect(page).not_to have_content "Folder zip You are not"
  end

  
end
