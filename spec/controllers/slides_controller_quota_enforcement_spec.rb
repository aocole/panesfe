require 'rails_helper'
RSpec.describe SlidesController, :type => :controller do
  it "should return sane errors for quota exceeded" do
    quota_user = FactoryGirl.create(:user, custom_disk_quota_mb: 0)
    expect(quota_user.disk_quota_mb).to eq 0
    expect(quota_user.disk_available_mb).to eq 0
    user_slideshow = FactoryGirl.create(:slideshow, user: quota_user)
    sign_in quota_user
    expect {
      post :create, slideshow_id: user_slideshow.id, files: [file_upload], format: :json
    }.to change(Slide, :count).by(0)
    expect(quota_user.disk_available_mb).to eq 0
    expect(response.body).to have_content "exceed available disk quota"
  end

  def file_upload
    return ActionDispatch::Http::UploadedFile.new({
      :filename => 'cast-of-growing-pains.jpg',
      :type => 'image/jpeg',
      :tempfile => Rails.root.join('seed/images/cast-of-growing-pains.jpg')
    })
  end
end
