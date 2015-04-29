class Slideshow < Presentation
  validates :theme, presence:true
  has_many :slides
  belongs_to :theme
  accepts_nested_attributes_for :slides, allow_destroy: true, reject_if: proc { |attributes| 
    attributes['image'].blank? && attributes['image_cache'].blank?
  }

  def content
    ApplicationController.new.render_to_string(:partial => 'presentations/slideshow', :object => self)
    #ERB.new(File.read(Rails.root.join('lib', 'templates', 'slideshow.html.erb'))).result(binding)
  end



end
