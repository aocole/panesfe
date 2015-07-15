require 'carrierwave/orm/activerecord'
class Presentation < ActiveRecord::Base
  BROKEN_MESSAGE = {
    no_index_found: 'activerecord.errors.models.foldershow.attributes.folder_zip.no_index_found',
  }.with_indifferent_access

  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}
  validate :foldershow_xor_slideshow
  validates :broken_message, inclusion: {in: BROKEN_MESSAGE.values}, allow_nil: true

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

  def mark_broken!(message_key)
    self.broken_message = BROKEN_MESSAGE[message_key]
    self.save!
  end
end
