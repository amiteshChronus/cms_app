class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

	def not_found
	  raise ActionController::RoutingError.new('Not Found')
	  
	end
end
