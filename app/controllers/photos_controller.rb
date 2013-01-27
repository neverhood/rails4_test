class PhotosController < ApplicationController

  respond_to :json, :html

  before_filter :authenticate_user!, only: [ :create, :destroy, :update, :edit ]
  before_filter :find_user!, only: [ :index ]

  before_filter :find_photo_as_owner!, only: [ :update, :destroy ]
  before_filter :find_photo!, only: [ :show ]
  before_filter :require_album_owner!, only: [ :create, :update ]

  def index
    @photos = @user.photos.without_album.page( params[:page] )

    respond_to do |format|
      format.html {}
      format.json { render json: { photos: render_to_string(partial: 'photo', collection: @photos), last: @photos.last_page? } }
    end
  end

  def edit
    # collection route
    @albums = current_user.albums.select([:name, :id])
    @photos = current_user.photos.without_album.page( params[:page] )

    respond_to do |format|
      format.html {}
      format.json { render json: { entries: render_to_string(partial: 'edit', collection: @photos, as: :photo), last: @photos.last_page? } }
    end
  end

  def create
    photo = current_user.photos.create(photo_params)

    if photo.album_id.present?
      # render with album name
      @photo = Photo.where(id: photo.id).select('photos.*, albums.name AS album_name').joins(:album).first
    else
      @photo = photo
    end

    render json: { photo: render_to_string(partial: 'photo', locals: { photo: @photo }) }
  end

  def show
  end

  def destroy
    @photo.destroy

    respond_with @photo
  end

  def update
    @photo.update_attributes(photo_params)
    @photo.touch(:created_at) if photo_params[:album_id].present?

    respond_with @photo
  end

  private

  def find_photo_as_owner!
    @photo = current_user.photos.find_by(id: params[:id])

    render_not_found! if @photo.nil?
  end

  def photo_params
    if params[:photo].present?
      params[:photo][:image] = params[:photo][:image].last if params[:photo][:image].is_a?(Array)
    end

    params.require(:photo).permit(:description, :album_id, :image)
  end

  def find_photo!
    @photo = Photo.find_by(id: params[:id])

    render_not_found! if @photo.nil?
  end

  def require_album_owner!
    if photo_params[:album_id].present?
      render_not_found! if current_user.albums.where(id: photo_params[:album_id]).none?
    end
  end

end
