class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_active_admin_user!
    authenticate_user!
    flash[:alert] = 'You are not authorized!' unless current_user.role?(:admin)
  end
end
