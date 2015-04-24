require 'rails_helper'
describe "quota enforcement" do
  let(:user){FactoryGirl.build_stubbed(:user, custom_disk_quota_mb: 2)}
  let(:presentation){FactoryGirl.build_stubbed(:presentation, user: user)}
  it "should allow uploading if disk available" do
    Dir.mktmpdir do |tmpdir|
      allow(user).to receive(:upload_dir) {tmpdir}
      expect{store_a_file}.not_to raise_error
    end
  end

  it "should not allow uploading if no disk available" do
    Dir.mktmpdir do |tmpdir|
      allow(user).to receive(:upload_dir) {tmpdir}
      # the file is 562K, so the 4th store should exceed the 2mb quota
      expect(user.disk_available_mb).to eq(user.disk_quota_mb)
      expect{store_a_file}.not_to raise_error
      dir_size = 0.6471662521362305 # determined empirically
      slop = 0.100
      expect(user.disk_available_mb).to be > (user.disk_quota_mb - dir_size - slop)
      expect(user.disk_available_mb).to be < (user.disk_quota_mb - dir_size + slop)

      expect{store_a_file}.not_to raise_error
      expect{store_a_file}.not_to raise_error
      Rails.logger.debug "User's upload dir: "
      Rails.logger.debug `ls -lR #{user.upload_dir}`
      expect(user.disk_available_mb).to be > 0
      expect(user.disk_available_mb).to be < 0.75

      expect{store_a_file}.to raise_error(/quota/i)
      expect(user.disk_available_mb).to be > 0
    end
  end

  it "should have UI for quota errors" do
    skip "Can't figure out how to get jquery-file-upload to work in an integration test"
    quota_user = FactoryGirl.create(:user, custom_disk_quota_mb: 0)
    user_presentation = FactoryGirl.create(:presentation, user: quota_user)
    Dir.mktmpdir do |tmpdir|
      allow(quota_user).to receive(:upload_dir) {tmpdir}

      log_in_as quota_user
      visit edit_presentation_path(user_presentation.id)
      expect(current_path).to eq edit_presentation_path(user_presentation.id)
      file = File.join(Rails.root, 'seed/images/cast-of-growing-pains.jpg')
      # include_hidden_fields do
        attach_file('files[]', file)
      # end
    end
  end

  it "should display quota on presentation edit page" do
    quota_user = FactoryGirl.create(:user, custom_disk_quota_mb: 3)
    user_presentation = FactoryGirl.create(:presentation, user: quota_user)
    Dir.mktmpdir do |tmpdir|
      allow(quota_user).to receive(:upload_dir) {tmpdir}
      log_in_as quota_user
      visit edit_presentation_path(user_presentation.id)
      expect(page).to have_content "3 MB"
    end
  end

  def store_a_file
    slide = presentation.slides.build()
    slide.user = user
    uploader = ImageUploader.new(slide, :image)
    allow(uploader).to receive(:filename) {SecureRandom.uuid}
    File.open(File.join(Rails.root, 'seed/images/cast-of-growing-pains.jpg')) do |f|
      uploader.store!(f)
    end
  end

end
