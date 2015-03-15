class PostsController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :set_public_feed, except: :index

  def index
    current_user.channels.each(&:fetch) if params[:fetch]
    @posts = current_user.posts.newest_on_top

    respond_to do |format|
      format.html
      format.atom { render layout: false }
      # format.js { render 'index.coffee' }
    end
  end

  # GET tags/:tag/posts
  def tagged
    @tag = params[:tag]
    # channels = Channel.published_and_personal_for(current_user)
    #   .tagged_with(params[:tag]).pluck(:id)
    channels = @channels.tagged_with params[:tag]
    channels.each(&:fetch) if params[:fetch]

    channels = channels.pluck(:id)
    @posts = Post.where('channel_id IN (?)', channels).newest_on_top
    render :index
  end

  # GET channel/:id/posts
  def channel_index
    channel = @channels.find_by id: params[:id]
    # channel = Channel.published_and_personal_for(current_user)
    #   .find_by id: params[:id]
    channel.delay.fetch if params[:fetch]

    respond_to do |format|
      if channel
        @posts = channel.posts.newest_on_top

        format.html { render :index }
        format.js   { render 'index.coffee' }
        format.atom { render :index }
      else
        msg = t 'devise.failure.unauthenticated'
        format.html { redirect_to root_path, alert: msg }
        format.js   { head :unauthorized }
      end
    end
  end

  private

  def set_public_feed
    user = User.find_by(token: params[:token]) if params[:token]
    user ||= current_user

    @channels = Channel.published_and_personal_for user # all public channels

    msg = t 'devise.failure.unauthenticated'
    redirect_to root_path, alert: msg if @channels.empty?
  end
end
