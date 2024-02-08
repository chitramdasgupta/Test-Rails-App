class PostsController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.all
  end

  private

  def require_login
    unless logged_in?
      redirect_to root_url, alert: "You must be logged in to access this page."
    end
  end
end
