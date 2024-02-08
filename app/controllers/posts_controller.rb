# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  private

  def require_login
    return if logged_in?

    respond_to do |format|
      format.html { redirect_to root_url, alert: 'You must be logged in to access this page.' }
      format.json { render json: { error: 'You must be logged in to access this page.' }, status: :unauthorized }
    end
  end
end
