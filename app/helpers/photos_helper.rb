module PhotosHelper
  def item_checkbox_for photo, item
    _photo_items[photo.id] = photo.photo_items.select { |photo_item| photo_item.visible? }.map(&:item_id)

    check_box_for(photo, item) + label_for(item)
  end

  private

  def label_for item
    t "items.#{@user.sex}.#{item.name}"
  end

  def check_box_for photo, item
    check_box_tag "item-#{item.id}", nil, existing_photo_item?(photo, item), data: { photo_id: photo.id }
  end

  def existing_photo_item? photo, item
    _photo_items[photo.id].include?(item.id)
  end

  def _photo_items
    @_photo_items ||= {}
  end
end
