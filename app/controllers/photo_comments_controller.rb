class PhotoCommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_photo!, only: [ :create ]
  before_filter :find_photo_comment!, only: [ :destroy, :update ]

  after_filter :create_response_entry, only: [ :create ], if: -> { @photo_comment.present? and @photo_comment.persisted? and @photo.user_id != current_user.id }

  def create
    @photo_comment = current_user.photo_comments.create(photo_comment_params)

    render json: { comment: render_to_string(partial: 'photo_comment', locals: { photo_comment: @photo_comment }) }
  end

  def update
    @photo_comment.update(photo_comment_params.tap { |comment_params| comment_params.delete(:photo_id) })

    render nothing: true, status: 202
  end

  def destroy
    @photo_comment.destroy

    render nothing: true, status: 202
  end

  private

  def find_photo_comment!
    @photo_comment = current_user.photo_comments.find_by(id: params[:id])
    render_not_found! if @photo_comment.nil?
  end

  def find_photo!
    @photo = Photo.find_by(id: photo_comment_params[:photo_id])
    render_not_found! if @photo.nil?
  end

  def photo_comment_params
    params.require(:photo_comment).permit(:photo_id, :body)
  end

  def create_response_entry
    @photo_comment.create_response_entry(author_id: current_user.id, user_id: @photo.user_id)
  end
end
