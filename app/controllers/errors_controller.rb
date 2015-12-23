class ErrorsController < ApplicationController

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end


  def raise_action_not_found
    raise AbstractController::ActionNotFound.new( )
  end

  def raise_invalid_authenticity_token
    raise ActionController::InvalidAuthenticityToken.new()
  end
end
