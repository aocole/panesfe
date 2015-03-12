class Theme < ActiveRecord::Base
  belongs_to :user
  has_many :presentations
end
