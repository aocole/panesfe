require 'rails_helper'

RSpec.describe User do
  let(:user) { User.new }

  describe "initialization" do

    it 'creates a new user with a minimum set of attributes' do
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :password, :provider, :uid])

      user.provider = 'identity'
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :password, :uid])

      user.provider = 'google_oauth2' # should get rid of password error also
      expect(user.save).to be_falsy
      expect(user.errors.keys.sort).to eq([:email, :uid])

      user.email = user.uid = 'aocole@oui.st'
      user.role = User.roles['user']
      expect(user.save).to be_truthy
    end  
  end

  describe 'quotas' do
    # users have to have an ID in order to calculate quotas
    let(:quota_user) {FactoryGirl.build_stubbed(:user)}

    it "should have usage & available for an unsaved user" do
      expect(user.disk_available_mb).to eq(0)
      expect(user.disk_used_mb).to eq(0)
    end

    it "should have a default quota" do
      expect(user.disk_quota_mb).to eq(GrowingPanes.config['default_disk_quota_mb'])
      expect(user.disk_quota_mb).to be_a(Numeric)
    end

    it "can be customized per-user" do
      expect(quota_user.disk_quota_mb).to eq(GrowingPanes.config['default_disk_quota_mb'])
      custom = rand(1000)
      quota_user.custom_disk_quota_mb = custom
      expect(quota_user.disk_quota_mb).to eq custom
      expect(quota_user.disk_available_mb).to eq custom
    end

    it "should have available disk space" do
      expect(quota_user.disk_available_mb ).to eq(quota_user.disk_quota_mb)
      expect(quota_user.disk_available_mb ).to be > 0
    end

    it "creating upload dir should not change available disk space" do
      quota_user.ensure_upload_dir
      expect(quota_user.disk_available_mb ).to eq(quota_user.disk_quota_mb)
    end

    it "should have 0 available disk if quota is 0" do
      custom = 0
      quota_user.custom_disk_quota_mb = custom
      expect(quota_user.disk_quota_mb).to eq custom
      expect(quota_user.disk_available_mb).to eq custom
      quota_user.ensure_upload_dir
      expect(quota_user.disk_available_mb).to eq custom
    end

    it "should recognize changes in disk usage" do
      before = quota_user.disk_available_b
      quota_user.ensure_upload_dir
      FileUtils.cp(Rails.root.join('seed/images/cast-of-growing-pains.jpg'), quota_user.absolute_upload_path)
      expect(quota_user.disk_available_b).to be < before
    end

  end

end
