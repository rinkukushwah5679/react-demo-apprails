class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:email, :password,:password_confirmation, :first_name, :last_name, :address, :image, :phone, :country)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |user|
      user.permit(:email, :password)
    end
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(:email, :password,:password_confirmation, :current_password, :first_name, :last_name, :address, :image, :phone, :country)
    end
  end
end
