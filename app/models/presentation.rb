require 'carrierwave/orm/activerecord'
class Presentation < ActiveRecord::Base
  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}
  validate :foldershow_xor_slideshow

  def slideshow?
    kind_of? Slideshow || type == Slideshow.name
  end

  def foldershow?
    kind_of? Foldershow || type == Foldershow.name
  end

  def foldershow_xor_slideshow
    unless slideshow? ^ foldershow?
      errors.add(:base, :foldershow_xor_slideshow)
    end
  end
end
