class ApplicationController < ActionController::Base
  protected

  def authenticate_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
