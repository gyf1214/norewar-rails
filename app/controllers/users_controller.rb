class UsersController < ApplicationController
	def create
		require_params :name, :password
		unless User.find_by_name(params[:name]).nil?
			raise ClientException.new "User with the same name exists!"
		end
		@user = User.create name: params[:name], password: params[:password]
		session[:user_id] = @user._id
		render json: { success: true }
	end

	def logout
		unless session[:user_id].nil?
			session[:user_id] = nil
		end
		render nothing: true
	end

	def login
		require_params :name, :password
		@user = User.find_by_name_and_password params[:name], params[:password]
		raise ClientException.new "Login Failed!" if @user.nil?
		session[:user_id] = @user._id
		render json: { success: true }
	end
end
