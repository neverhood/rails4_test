# encoding: UTF-8

class Album < ActiveRecord::Base
  belongs_to :user

  has_many :photos, :dependent => :nullify # default?
  has_one  :cover_photo, class_name: 'Photo', foreign_key: 'id', primary_key: 'cover_photo_id'

  validates :name, uniqueness: { scope: 'user_id' }, format: { with: /\A[a-zA-Zа-яА-Я0-9\s_-]+\z/ }, length: { within: (1..100) }
  validates :transliterated_name, uniqueness: { scope: 'user_id' }
  validates :description, length: { within: (1..5000) }, allow_nil: true

  before_validation -> { self.name = self.name.strip }, if: -> { name_changed? }
  before_validation -> { self.transliterated_name = self.name.parameterize }, if: -> { name_changed? }
  before_validation -> { self.description = nil if self.description.strip.blank? }, if: -> { description_changed? }

  def cover
    cover_photo_id.present?? cover_photo : photos.first
  end

  def set_cover! photo
    update_columns(cover_photo_id: photo.id) unless cover_photo_id == photo.id
  end
end
