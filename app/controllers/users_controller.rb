# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create], if: -> { request.format.json? }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json { render json: { message: 'User was successfully created.', user: @user }, status: :created }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:error] = 'Please enter the data properly'
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
