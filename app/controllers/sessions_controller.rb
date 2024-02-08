# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy], if: -> { request.format.json? }

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if request.format.json?
        user.generate_token
        render json: { token: user.token }, status: :ok
      else
        session[:user_id] = user.id
        redirect_to posts_path, notice: 'Logged in successfully'
      end
    else
      render json: { error: 'Email or password is invalid' }, status: :unauthorized
    end
  end

  def destroy
    if request.format.json?
      token = request.headers['Authorization']&.match(/Token token=\"([^\"]+)\"/)&.captures&.first
      user = User.find_by(token: token)

      if user
        user.clear_token
        head :no_content
      else
        render json: { error: 'Invalid token or already logged out.' }, status: :unauthorized
      end
    else
      session.delete(:user_id)
      @current_user = nil
      redirect_to root_url, notice: 'Logged out successfully.'
    end
  end
end
