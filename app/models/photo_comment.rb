class PhotoComment < ActiveRecord::Base
  include Respondable

  belongs_to :photo
  belongs_to :user

  validates :body, length: { within: (1..1000) }

  default_scope -> { order('photo_comments.created_at DESC') }
end
