class Api::V1::RegistrationsController < Api::V1::ApiController
	skip_before_action  :verify_authenticity_token 
	before_action :authenticate_user!, except: [:create]
	eval(IO.read('doc/api_doc/sign_up.html'), binding)
  def create
    user = User.new(registration_params)
    if user.save
      return render json: {status: 200, data: {user: user}, :message =>"Successfuly Signup"} 
    else
      return render json: {status: 401, data: {user: nil, errors: user.errors}, :message =>"SignUp Rollback"} 
    end
  end



  eval(IO.read('doc/api_doc/edit_profile.html'), binding)
  def update
    begin
			user =  current_user
			user.email = params[:email] if params[:email].present?
			user.password = params[:password] if params[:password].present?
			user.first_name = params[:first_name] if params[:first_name].present?
			user.last_name = params[:last_name] if params[:last_name].present?
			user.image = params[:image] if params[:image].present?
			user.address = params[:address] if params[:address].present?
			user.country = params[:country] if params[:country].present?
			user.phone = params[:phone] if params[:phone].present?
      user.dob = params[:dob] if params[:dob].present?
			if user.save!
				return render json: {status: 200, data: {user: user}, :message =>"User Profile Successfully Updated"} 
      else
        # error_section
        rescue_section
      end
    rescue
      rescue_section
    end
  end
  def profile
    user = current_user
    render json: user
  end

  def edit
    user = User.find(params[:id])
    render json: user
  end

  def user_update
    begin
      user = User.find(params[:id])
      user.email = params[:email] if params[:email].present?
      user.password = params[:password] if params[:password].present?
      user.first_name = params[:first_name] if params[:first_name].present?
      user.last_name = params[:last_name] if params[:last_name].present?
      user.image = params[:image] if params[:image].present?
      user.address = params[:address] if params[:address].present?
      user.country = params[:country] if params[:country].present?
      user.phone = params[:phone] if params[:phone].present?
      if user.save!
        return render json: {status: 200, data: {user: user}, :message =>"User Successfully Updated"} 
      else
        # error_section
        rescue_section
      end
    rescue
      rescue_section
    end
  end

  def reset_password
    begin
      if params[:email].nil?
          # render :status=>400,
          # :json=>{:message=>"The request must contain the user email "}
          # return
          rescue_section
      end
      @user = User.find_by_email(params[:email])
      byebug
      if @user.present?
        @user.send_reset_password_instructions
        render :status=>200, :json=>{:status => true,:message=>'New Password Sent To Email'
            }
      else
        # render :status=>401, :json=>["mail not exist"]
        rescue_section
      end
    rescue
      rescue_section
    end
  end

  private
  def error_section
    return render json: user.errors, status: :unprocessable_entity
  end
  def rescue_section
    return render json: {status: 500, data: {news: nil}, message: "Something Went Wrong"}
  end
   
  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :image, :phone, :address, :country, :dob)
  end
end