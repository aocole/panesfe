require 'carrierwave/orm/activerecord'
class Presentation < ActiveRecord::Base
  BROKEN_MESSAGE_KEYS = %W{
    no_index_found
    slide_timeout
    presentation_timeout
  }

  serialize :broken_message_keys, Array

  belongs_to :user
  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user}
  validate :foldershow_xor_slideshow
  validate :check_broken_message_keys

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
    self.broken_message_keys += [message_key]
    self.save!
  end

  def broken_messages?
    !broken_message_keys.blank?
  end

  def self.broken_message_to_i18n_key(key)
    "activerecord.errors.models.presentation.broken_message.#{key}"
  end

  def check_broken_message_keys
    broken_message_keys.each do |key|
      errors.add(:broken_message_keys, "\"#{key}\" is not a valid broken message") unless BROKEN_MESSAGE_KEYS.include? key
    end
  end

end
