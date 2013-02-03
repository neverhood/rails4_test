class ProfilesController < ApplicationController
  respond_to :html, :json

  before_filter :find_user!, only: [ :show ]

  # Create
  before_filter :authenticate_user!, only: [ :create ]
  before_filter :require_valid_post_type!, only: [ :create ]
  before_filter :find_profile!, only: [ :create ]

  after_filter :create_response_entry, only: [ :create ],
    if: -> { @profile_entity.present? and @profile_entity.persisted? and @profile_entity.class.respondable? and @profile_entity.profile.user_id != current_user.id }

  def show
    @conversation = current_user.conversation_with(@user) if current_user.has_conversation_with?(@user)
    @profile_posts = @user.profile_posts.includes(:user).references(:user).page(params[:page])

    respond_to do |format|
      format.html {}
      format.json do
        render json: { posts: render_to_string(partial: 'profile_posts/profile_post', collection: @profile_posts), last: @profile_posts.last_page? }
      end
    end
  end

  def create
    @profile_entity = profile_post_class.create(profile_post_params.merge(user_id: current_user.id).tap { |attributes| attributes.delete(:post_type) })

    respond_to do |format|
      if @profile_entity.persisted?
        format.html { redirect_to user_path(current_user), notice: I18n.t('flash.profiles.create.notice') }
        format.json { render json: { post: render_to_string(partial: 'profile_posts/profile_post', locals: { profile_post: @profile_entity.profile_post }) } }
      else
        format.html { redirect_to user_path(current_user), notice: I18n.t('flash.profiles.create.alert') }
        format.json { respond_with @profile_entity }
      end
    end
  end

  private

  def require_valid_post_type!
    render_not_found! unless ProfilePost::POST_TYPES.include?(profile_post_params[:post_type].to_i)
  end

  def find_profile!
    render_not_found! unless Profile.where(id: profile_post_params[:profile_id]).any?
  end

  def profile_post_params
    params.require(:profile_post).permit(:profile_id, :post_type, :body)
  end

  def profile_post_class
    POLYMORPHIC_INTEGER_TYPES[profile_post_params[:post_type].to_i].constantize
  end

  def create_response_entry
    @profile_entity.create_response_entry(author_id: current_user.id, user_id: @profile_entity.profile.user_id)
  end

end
