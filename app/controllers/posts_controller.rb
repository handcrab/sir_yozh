class PostsController < ApplicationController
  before_action :authenticate_user!, only: :index
  # before_action :fetch_posts
  before_action :set_public_feed, except: :index

  def index 
    current_user.channels.each(&:fetch) if params[:fetch]
    @posts = current_user.posts.newest_on_top

    respond_to do |format|
      format.html
      format.atom { render layout: false }
    end
  end

  # GET tags/:tag/posts
  def tagged
    # @tag = params[:tag]
    # current_user.channels.each(&:fetch) if params[:fetch]
    # channels = current_user.channels.tagged_with(params[:tag]).pluck(:id)
    # @posts = Post.where('channel_id IN (?)', channels).newest_on_top
    @tag = params[:tag]
    # channels = Channel.published_and_personal_for(current_user).tagged_with(params[:tag]).pluck(:id)
    channels = @channels.tagged_with(params[:tag]) #.pluck(:id)
    channels.each(&:fetch) if params[:fetch]
    channels = channels.pluck(:id)
    @posts = Post.where('channel_id IN (?)', channels).newest_on_top

    render :index
  end

  # GET channel/:id/posts
  def channel_index
    channel = @channels.find_by id: params[:id]
    # channel = Channel.published_and_personal_for(current_user).find_by id: params[:id]
        
    if channel
      channel.delay.fetch if params[:fetch]
      @posts = channel.posts.newest_on_top

      render :index
    else
      msg = t('devise.failure.unauthenticated')
      redirect_to root_path, alert: msg unless channel
    end    
  end

  private
  def set_public_feed
    # channel = Channel.published_and_personal_for(current_user).find_by id: params[:id]
    if params[:token]
      user = User.find_by token: params[:token]
    end
    user ||= current_user
    # all public channels
    @channels = Channel.published_and_personal_for user

    msg = t('devise.failure.unauthenticated')
    redirect_to root_path, alert: msg if @channels.empty?
  end
end
