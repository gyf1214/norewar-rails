class UsersController < ApplicationController
	def create
		require_params params, false, :name, :password
		captcha!
		unless User.find_by_name(params[:name]).nil?
			raise ClientException.new "User with the same name exists!"
		end
		@user = User.create name: params[:name], password: params[:password], session: session[:session_id]
		session[:user_id] = @user._id
		render json: { success: true }
	end

	def logout
		@user = User.find session[:user_id]
		@user.unset :session unless @user.nil? || @user.session != session[:session_id]
		session[:user_id] = nil unless session[:user_id].nil?
		redirect_to root_path
	end

	def login
		require_params params, false, :name, :password
		captcha!
		@user = User.find_by_name_and_password params[:name], params[:password]
		raise ClientException.new "Login Failed!" if @user.nil?
		session[:user_id] = @user._id
		@user.set session: session[:session_id]
		render json: { success: true }
	end

	private

	def captcha!
		#require_params params, false, :recaptcha_response_field
		#puts params[:recaptcha_response_field]
		#puts verify_recaptcha
		#raise ClientException.new 'We cannot confirm you are a human!' unless verify_recaptcha
	end
end
