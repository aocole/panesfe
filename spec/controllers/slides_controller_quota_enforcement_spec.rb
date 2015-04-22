require 'rails_helper'
RSpec.describe SlidesController, :type => :controller do
  it "should return sane errors for quota exceeded" do
    Dir.mktmpdir do |tmpdir|
      quota_user = FactoryGirl.create(:user, custom_disk_quota_mb: 0)
      allow(quota_user).to receive(:upload_dir) {tmpdir}
      expect(quota_user.disk_quota_mb).to eq 0
      expect(quota_user.disk_available_mb).to eq 0
      user_presentation = FactoryGirl.create(:presentation, user: quota_user)
      sign_in quota_user
      expect {
        post :create, presentation_id: user_presentation.id, files: [file_upload], format: :json
      }.to change(Slide, :count).by(0)
      expect(quota_user.disk_available_mb).to eq 0
      expect(response.body).to have_content "exceed available disk quota"
    end
  end

  def file_upload
    return ActionDispatch::Http::UploadedFile.new({
      :filename => 'cast-of-growing-pains.jpg',
      :type => 'image/jpeg',
      :tempfile => Rails.root.join('seed/images/cast-of-growing-pains.jpg')
    })
  end
end
