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
  def check_admin_permission
    return render json: {status: 403, data: {users: nil}, :message =>"Admin permission is required."} unless current_user.admin?
  end

end
