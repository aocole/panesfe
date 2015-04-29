class Slide < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :slideshow
  has_one :user, through: :slideshow

  def is_video?
    image.content_type == "application/mp4"
  end

  def is_image?
    !is_video?
  end

  def name
    image.file.filename
  end

end
