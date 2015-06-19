class Users::SessionsController < Devise::SessionsController

  # add_crumb "My profile", :edit_user_registration_path, :only => :edit

  def new
    @body_class = 'registration-page'
    super
  end

  protected
  def after_sign_in_path_for resource
    @cart.try(:update!, user: resource)
    super resource
  end

end
