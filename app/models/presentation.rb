require 'carrierwave/orm/activerecord'
class Presentation < ActiveRecord::Base
  belongs_to :user
  validates :name, :user, presence: true
  validates :theme, presence:true, if: :slideshow?
  validates :name, uniqueness: {scope: :user}
  validate :folder_xor_slideshow
  has_many :slides
  belongs_to :theme
  accepts_nested_attributes_for :slides, allow_destroy: true, reject_if: proc { |attributes| 
    attributes['image'].blank? && attributes['image_cache'].blank?
  }

  mount_uploader :folder_zip, ZipUploader

  def content
    ApplicationController.new.render_to_string(:partial => 'presentations/slideshow', :object => self)
    #ERB.new(File.read(File.join(Rails.root, 'lib', 'templates', 'slideshow.html.erb'))).result(binding)
  end

  # The only thing required for a slideshow is a theme, since it's possible
  # for the theme to display things even if there are no slides.
  def slideshow?
    !theme.blank?
  end

  def folder?
    !folder_zip.blank?
  end

  def folder_xor_slideshow
    unless slideshow? ^ folder?
      errors.add(:base, :folder_xor_slideshow)
    end
  end
end
