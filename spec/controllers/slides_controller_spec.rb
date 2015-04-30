require 'rails_helper'
RSpec.describe SlidesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  # this is needed to repopulate jquery-file-upload
  it "should provide json version of slideshow" do
    sign_in user
    user_slideshow = FactoryGirl.create(:slideshow, user: user)
    get :index, slideshow_id: user_slideshow.id, format: :json
    assert_response 200
  end

  it "should delete a slide" do
    sign_in user
    user_slideshow = FactoryGirl.create(:slideshow, user: user)
    slide = user_slideshow.slides.build()
    slide.image = File.open(Rails.root.join('seed/images/cast-of-growing-pains.jpg'))
    user_slideshow.save!
    expect(user_slideshow.slides.size).to eq 1
    expect(slide.id).not_to be_nil

    delete :destroy, id: slide.id, format: :json
    assert_response 200
  end
end
