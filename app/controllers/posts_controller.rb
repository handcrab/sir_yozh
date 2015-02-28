class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.order published_at: :desc
  end
end
