class Users::RegistrationsController < Devise::RegistrationsController

  # add_crumb "My profile", :edit_user_registration_path, :only => :edit

  def new
    @body_class = 'registration-page'
    super
  end

  def update
    @user = current_user
    # user_params = params[:user]

    if user_params[:current_password].blank?
      user_params.delete(:current_password)
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
      if @user.update_attributes(user_params)
        sign_in @user, :bypass => true
        redirect_to edit_user_registration_path
      else
        flash[:alert] = 'Ошибка'
        render :edit
      end
    else
      if @user.update_with_password(user_params)
        sign_in @user, :bypass => true
        redirect_to edit_user_registration_path
      else
        flash[:alert] = 'Ошибка'
        render :edit
      end
    end
  end

  protected

  def after_sign_up_path_for resource
    @cart.try(:update!, user: resource)
    stored_location_for(:user) || root_path
  end

  def user_params
    params.require(:user).permit :current_password, :password, :password_confirmation,
                                 :email, :fname, :lname,
                                 address_attributes:
                                     [:phone, :email, :username, :address ]
  end

  def sign_up_params
    user_params
  end

end
