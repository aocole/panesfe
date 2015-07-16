class Slide < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :slideshow, touch: true
  has_one :user, through: :slideshow
  include RankedModel
  ranks :row_order, with_same: :slideshow_id

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
