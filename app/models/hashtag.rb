class Hashtag < ActiveRecord::Base
  belongs_to :user
  validates :hashtag, presence: true
  validates_format_of :hashtag, :with => /\A[a-zA-Z0-9]*\z/, :message => "Only letters and numbers allowed"
  before_save :lowercase

  def lowercase
    self.hashtag = self.hashtag.to_s.downcase
  end
end
