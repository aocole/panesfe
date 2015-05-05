# encoding: utf-8
require 'carrierwave/video_thumbnailer'
class ImageUploader < BaseUploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::VideoThumbnailer

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process resize_to_limit: [3840, 2160], if: :is_image?
  #
  # def scale(width, height)
  #   # do something
  # end

  version :thumb do
    process resize_and_pad: [150, 150], if: :is_image? 
    process video_thumb: [150, 150], if: :is_video?# do
    #   binding.pry
    #   process convert: 'png'
    # end

    def full_filename(for_file=file)
      super.chomp('mp4') + 'png'
    end
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

end
