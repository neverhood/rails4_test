class PhotoItem < ActiveRecord::Base
  belongs_to :photo
  belongs_to :item

  scope :with_item, -> { includes(:item) }

  def liked!
    increment! :likes_count, 1
  end

  def toggle_visibility!
    update_column(:visible, !visible)
  end

  def liked_today_by? user
  end
end
