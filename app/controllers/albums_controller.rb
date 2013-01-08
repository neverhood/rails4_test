class AlbumsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!, only: [ :create, :update, :destroy, :new, :edit ]

  before_filter :find_user!,  only: [ :show, :index ]
  before_filter :find_album_as_owner!, only: [ :edit, :update, :destroy ]
  before_filter :find_album!, only: [ :show ]

  def index
    @albums = @user.albums.page(params[:page]).order('created_at DESC')
    @album  = current_user.albums.new if ( user_signed_in? and @user.id == current_user.id )
  end

  def show
    @photos = @album.photos.with_album_name.page( params[:page] ).per(50)

    respond_to do |format|
      format.html {}
      format.json { render json: { photos: render_to_string(partial: 'photos/photo', collection: @photos), last: @photos.last_page? } }
    end
  end

  def new
    @album = current_user.albums.new
  end

  def create
    @album, @user = current_user.albums.create(album_params), current_user

    respond_to do |format|
      format.html { redirect_to :back, notice: ( @album.persisted?? I18n.t('flash.albums.create.alert') : I18n.t('flash.albums.create.notice') ) }
      format.json do
        if @album.valid?
          render json: { album: render_to_string(partial: 'album', locals: { album: @album }) }
        else
          respond_with @album
        end
      end
    end
  end

  def edit
    @photos = @album.photos.with_album_name.page( params[:page] ).per(50)
    @albums = current_user.albums.select([:name, :id])

    respond_to do |format|
      format.html {}
      format.json { render json: { entries: render_to_string(partial: 'photos/edit', collection: @photos, as: :photo), last: @photos.last_page? } }
    end
  end

  def update
    @album.update_attributes(album_params)

    redirect_to user_album_path(user_id: current_user, album_name: @album.transliterated_name), notice: I18n.t('flash.albums.update.notice')
  end

  def destroy
    @album.destroy

    redirect_to user_albums_path(current_user), notice: I18n.t('flash.albums.destroy.notice')
  end

  private

  def find_album!
    @album = @user.albums.find_by(transliterated_name: params[:album_name])
    render_not_found! if @album.nil?
  end

  def find_album_as_owner!
    @album = current_user.albums.where(id: params[:id]).first
    render_not_found! if @album.nil?
  end

  def album_params
    params.require(:album).permit(:name, :description)
  end

end
