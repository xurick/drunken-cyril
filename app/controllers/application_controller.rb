class ApplicationController < ActionController::Base
  protect_from_forgery
  # SessionHelper resides in app/helpers/session_helper.rb
  # this is making all methods defined in SessionHelper available across controller and view
  include SessionsHelper

  private
  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  helper_method :mobile_device?
end
