class Api::V1::SessionsController < Api::V1::ApiController
	skip_before_action  :verify_authenticity_token
	before_action :authenticate_user!, except: [:create]

	eval(IO.read('doc/api_doc/sign_in.html'), binding) 
  def create
    begin
      return render json: {status: 401, data: {user: nil}, message: "Request Parameter not valid"} unless params[:user]
      email = params[:user][:email]
      password = params[:user][:password]
      return render json: {status: 401, data: {user: nil}, message: "The request must contain the email and password."} unless email && password
      @user = User.where(email: email).first
      return render json: {status: 401, data: {user: nil}, message: "Invalid email or password"} if @user.blank?
      return render json: {status: 401, data: {user: nil}, message: "Invalid email or password"} if not @user.valid_password?(password)
      return render json: {status: 200, data: {user: current_user}, message: "You have allready Login."} if current_user
      return render json: {status: 200, data: {user: @user}, message: "Login Successful"}
    rescue
      rescue_section
    end
  end

  eval(IO.read('doc/api_doc/sign_out.html'), binding) 
  def destroy
    current_user.authentication_token = nil
    current_user.save 
    return render json: {status: 200, data: nil, message: "Successfuly Log out"}
  end

  private
  def rescue_section
    return render json: {status: 500, data: {review: nil}, message: "Something Went Wrong"}
  end
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end