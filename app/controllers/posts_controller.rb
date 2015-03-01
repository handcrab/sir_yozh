class PostsController < ApplicationController
  before_action :authenticate_user!
  # before_action :fetch_posts

  def index    
    if params[:fetch]
      current_user.channels.each &:fetch
    end
    @posts = current_user.posts.order published_at: :desc

    respond_to do |format|
      format.html {}
      format.atom { render layout: false }
    end
  end

  # GET tags/:tag/posts
  def tagged
    # @channels = Channel.published_and_personal_for(current_user).tagged_with params[:tag]
    # @channels = current_user.channels.tagged_with params[:tag]    
    @tag = params[:tag]
    current_user.channels.each(&:fetch) if params[:fetch]
    channels = current_user.channels.tagged_with(params[:tag]).pluck(:id)
    @posts = Post.where('channel_id IN (?)', channels).newest_on_top

    render :index
  end

  # GET channel/:id/posts
  def channel_index
    channel = Channel.published_and_personal_for(current_user).find_by id: params[:id]
    msg = t('devise.failure.unauthenticated')
    redirect_to root_path, alert: msg unless channel

    channel.fetch if params[:fetch]
    @posts = channel.posts.newest_on_top

    render :index
  end
  # def fetch
  #   current_user.channels.each &:featch
  #   @posts = current_user.posts
  #   render :index
  # end  
end
