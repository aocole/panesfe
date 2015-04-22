# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  before :cache, :check_quota

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    raise "Can't upload images for an unknown user!" unless model.user
    return File.join(model.user.upload_dir, mounted_as.to_s, model.id.to_s)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_limit => [3840, 2160], :if => :is_image?
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb, :if => :is_image? do
    process :resize_and_pad => [150, 150]
  end

  version :thumb, :if => :is_video? do
    # Do nothing for now until video processing supported
  end

  def is_image? slide
    !is_video?(slide)
  end

  def is_video? slide
    slide.content_type =~ /video/i
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png mp4)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  QUOTA_FMT = "%.2f"
  def check_quota(new_file)
    file_size_mb = new_file.size.to_f/(1.megabyte)
    if file_size_mb > model.user.disk_available_mb
      raise GrowingPanes::WouldExceedQuotaError, 
        I18n.t("errors.messages.would_exceed_quota", attempted: QUOTA_FMT % file_size_mb, available: QUOTA_FMT % model.user.disk_available_mb)
    end
  end



end
