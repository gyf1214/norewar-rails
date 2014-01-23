class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	
	class ClientException < Exception
		attr_reader :message

		def initialize(message)
			@message = message
		end
	end

	rescue_from ClientException, with: :client_error

	def current_user
		@user = User.find session[:user_id]
		if @user.nil? || @user.session != session[:session_id]
			session[:user_id] = nil
			@user = nil
		end
		@user
	end

	def current_user!
		raise ClientException.new "Login required!" if session[:user_id].nil?
		@user = User.find session[:user_id]
		if @user.nil? || @user.session != session[:session_id]
			session[:user_id] = nil
			raise ClientException.new "Bad login!"
		end
		@user
	end

	protected

	def require_params(param, allow_empty, *pars)
		for x in pars
			raise ClientException.new "Field #{x} required!" if param[x].nil?
			raise ClientException.new "Field #{x} empty" if  !allow_empty && param[x].empty?
		end
	end

	def client_error(err)
		respond_to do |format|
			format.html do
				flash[:error] = err.message
				redirect_to error_path
			end
			format.json do
				render json: { error: err.message }
			end
			format.xml do
				render xml: { error: err.message }
			end
		end
	end
end
