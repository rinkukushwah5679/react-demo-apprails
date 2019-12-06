class Api::V1::ApiController < ApplicationController
	respond_to :json
	helper_method :current_user

	def current_user
    @current_user ||= User.where(authentication_token: request.headers['User-Token']).first
  end
  def authenticate_user!
    return render json:{error:'401 Unauthorized!'},status: 401 unless current_user
  end
end
