class PostsController < ApplicationController
  before_action :authenticate_user!

  def index    
    if params[:fetch]
      current_user.channels.each &:fetch
    end
    @posts = current_user.posts.order published_at: :desc
  end

  # def fetch
  #   current_user.channels.each &:featch
  #   @posts = current_user.posts
  #   render :index
  # end  
end
