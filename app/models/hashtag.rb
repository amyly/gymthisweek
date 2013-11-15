class Hashtag < ActiveRecord::Base
  belongs_to :user
  validates :hashtag, presence: true
  before_save :lowercase

  def lowercase
    self.hashtag = self.hashtag.to_s.downcase
  end
end
