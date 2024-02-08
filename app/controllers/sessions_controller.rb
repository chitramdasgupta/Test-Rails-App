# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create destroy]

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      handle_user_authentication(user)
    else
      handle_authentication_failure
    end
  end

  def destroy
    if request.format.json?
      handle_api_logout
    else
      handle_html_logout
    end
  end

  private

  def handle_user_authentication(user)
    if request.format.json?
      user.generate_token
      render json: { token: user.token }, status: :ok
    else
      session[:user_id] = user.id
      redirect_to posts_path, notice: 'Logged in successfully'
    end
  end

  def handle_authentication_failure
    respond_to do |format|
      format.json { render json: { error: 'Email or password is invalid' }, status: :unauthorized }
      format.html do
        flash.now[:alert] = 'Email or password is invalid'
        render 'new', status: :unprocessable_entity
      end
    end
  end

  def handle_api_logout
    token = request.headers['Authorization']&.match(/Token token="([^"]+)"/)&.captures&.first
    user = User.find_by(token:)

    if user
      user.clear_token
      head :no_content
    else
      render json: { error: 'Invalid token or already logged out.' }, status: :unauthorized
    end
  end

  def handle_html_logout
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_url, notice: 'Logged out successfully.'
  end
end
