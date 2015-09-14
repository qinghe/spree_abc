class ApplicationController < ActionController::Base
  protect_from_forgery

  # CUSTOM EXCEPTION HANDLING
  rescue_from StandardError do |e|
    handle_error(e)
  end

  protected

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
    end

  end
end
