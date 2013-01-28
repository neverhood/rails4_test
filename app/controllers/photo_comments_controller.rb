class PhotoCommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :locate_photo!, only: [ :create ]
  before_filter :find_photo_comment!, only: [ :destroy, :update ]

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

  def locate_photo!
    render_not_found! if Photo.where(id: photo_comment_params[:photo_id]).none?
  end

  def photo_comment_params
    params.require(:photo_comment).permit(:photo_id, :body)
  end

end
