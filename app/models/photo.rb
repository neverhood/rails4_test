class Photo < ActiveRecord::Base
  include Feedable

  mount_uploader :image, ImageUploader

  paginates_per 50

  belongs_to :user
  belongs_to :album
  has_many :photo_comments, :dependent => :destroy
  has_many :photo_items, :dependent => :destroy

  validates :description, length: { within: (0..1000) }, allow_nil: true

  default_scope -> { order('created_at DESC') }

  scope :without_album, -> { where(album_id: nil) }
  scope :with_album_name, -> { select('photos.*, albums.name AS album_name').joins(:album) }
  scope :with_items, -> { includes(:photo_items) }
end
