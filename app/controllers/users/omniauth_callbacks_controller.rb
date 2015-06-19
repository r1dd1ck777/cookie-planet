class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	skip_before_filter :authenticate_user!
	def all
		logger.info "omniauth controller"
    logger.info env["omniauth.auth"]
		user = User.from_omniauth(env["omniauth.auth"], current_user)

		if user.persisted?
			flash[:success] = t 'registration.complete'
      sign_in_and_redirect2(user)
		else
			session["devise.user_attributes"] = user.attributes
			redirect_to stored_location_for(:user)
		end
	end

	  def failure
      #handle you logic here..
      #and delegate to super.
      super
   end


  alias_method :facebook, :all
  alias_method :vkontakte, :all
	# alias_method :twitter, :all
	# alias_method :linkedin, :all
	# alias_method :github, :all
	# alias_method :passthru, :all
	# alias_method :google_oauth2, :all

  def sign_in_and_redirect2(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope
    sign_in(scope, resource, options)
    redirect_to stored_location_for(:user) || root_path # thanks_for_registration_path
  end
end
