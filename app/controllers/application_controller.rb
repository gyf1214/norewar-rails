class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	include ApplicationHelper
	rescue_from ClientException, with: :client_error

	protected

	def require_login
		raise ClientException.new "Login required!" if session[:user_id].nil?
		@user = User.find session[:user_id]
		raise ClientException.new "Bad login" if @user.nil?
	end

	def require_params(*pars)
		for x in pars
			raise ClientException.new "Field #{x} required!" if params[x].nil?
			break
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
