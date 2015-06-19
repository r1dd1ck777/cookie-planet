class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def orders
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_attributes(params.required(:user).permit(:password, :password_confirmation, :current_password))
      # Sign in the user by passing validation in case their password changed
      sign_in :user, @user, :bypass => true
      redirect_to my_profile_path
    else
      render :edit_password
    end
  end
end
