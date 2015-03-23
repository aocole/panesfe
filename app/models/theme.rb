class Theme < ActiveRecord::Base
  belongs_to :user
  has_many :presentations
  validates :user, presence: true
  before_validation :defaults

  def defaults
    self.content ||= ''
  end
end
