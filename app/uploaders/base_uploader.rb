# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base
  before :cache, :check_quota

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def self.store_dir
    raise "Can't get a store dir without an object to store."
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    raise "Can't upload files for an unknown user!" unless model.user
    @store_dir = File.join(model.user.upload_dir, mounted_as.to_s, model.id.to_s)
    return @store_dir
  end

  def cache_dir
    File.join(Rails.env, 'tmp_cache')
  end

  QUOTA_FMT = "%.2f"
  def check_quota(new_file)
    file_size_mb = new_file.size.to_f/(1.megabyte)
    if file_size_mb > model.user.disk_available_mb
      raise GrowingPanes::WouldExceedQuotaError, 
        I18n.t("errors.messages.would_exceed_quota", attempted: QUOTA_FMT % file_size_mb, available: QUOTA_FMT % model.user.disk_available_mb)
    end
  end

end
