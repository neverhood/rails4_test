class PhotoItemsController < ApplicationController
  before_filter :authenticate_user!

  before_filter :find_photo!, only: [ :toggle, :index ]
  before_filter :find_item!,  only: [ :toggle ]

  def index
    photo_items = @photo.photo_items.where(visible: true).pluck(:item_id)
    render json: { entries: render_to_string(partial: 'photo_items', locals: { photo: @photo, photo_items: photo_items }), status: 202 }
  end

  def toggle
    @photo_item = @photo.photo_items.find_by(photo_id: @photo.id, item_id: @item.id)

    if @photo_item.present?
      @photo_item.toggle_visibility!
    else
      @photo_item = @photo.photo_items.create(photo_id: @photo.id, item_id: @item.id)
    end

    render nothing: true, status: 202
  end

  private

  def find_photo!
    @photo = current_user.photos.find(params[:photo_id])
  end

  def find_item!
    @item = current_user.items.find(params[:item_id])
  end

end
