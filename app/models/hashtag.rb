class Hashtag < ActiveRecord::Base
  belongs_to :user
  validates :hashtag, presence: true
end
