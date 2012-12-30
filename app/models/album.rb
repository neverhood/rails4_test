# encoding: UTF-8

class Album < ActiveRecord::Base
  belongs_to :user

  validates :name, uniqueness: { scope: 'user_id' }, format: { with: /\A[a-zA-Zа-яА-Я0-9\s_-]+\z/ }, length: { within: (1..100) }
  validates :transliterated_name, uniqueness: { scope: 'user_id' }
  validates :description, length: { within: (1..5000) }, allow_nil: true

  before_validation -> { self.name = self.name.strip }, if: -> { name_changed? }
  before_validation -> { self.transliterated_name = self.name.parameterize }, if: -> { name_changed? }
  before_validation -> { self.description = nil if self.description.strip.blank? }, if: -> { description_changed? }

  def append photo_record
    photo_record.tap do |photo|
      photo.album_id = id
      photos << photo

      touch(:updated_at)
    end
  end

  def cover
    nil
  end
end
