class ApplicationController < ActionController::Base
  protect_from_forgery

  # CUSTOM EXCEPTION HANDLING
  rescue_from StandardError do |e|
    handle_error(e)
  end

  protected
  #https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:cellphone, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :cellphone, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:cellphone, :email, :password, :password_confirmation, :current_password) }    
  end

  def handle_error(e)
    if e
      logger.info "Rendering 404: #{e.message}"
    end
    case e
    when ActionController::RoutingError
      respond_to do |type|
        type.html { render :status => :not_found, :file    => "#{::Rails.root}/public/404", :formats => [:html], :layout => nil}
        type.all  { render :status => :not_found, :nothing => true }
      end
    else
      raise e
    end

  end
end
