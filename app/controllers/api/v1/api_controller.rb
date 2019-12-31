class Api::V1::ApiController < ApplicationController
	respond_to :json
	helper_method :current_user

	def current_user
		if request.headers['User-Token'].nil?
			@current_user ||= User.where(authentication_token: params[:token]).first
		else
    	@current_user ||= User.where(authentication_token: request.headers['User-Token']).first
   	end
  end
  def authenticate_user!
    return render json:{error:'401 Unauthorized!'},status: 401 unless current_user
  end
end
