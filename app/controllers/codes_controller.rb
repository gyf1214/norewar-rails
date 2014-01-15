class CodesController < ApplicationController
	before_action :require_login

	def new
		@code = Code.new
		@code.code = ''
	end

	def create
		require_params params, false, :code
		require_params params[:code], false, :name
		require_params params[:code], true, :code
		@user.codes.create name: params[:code][:name], code: params[:code][:code]
		redirect_to codes_path
	end

	def show
		require_params params, false, :id
		@code = @user.codes.find params[:id]
		raise ClientException.new "Code not found!" if @code.nil?
	end

	def index
		@codes = @user.codes
	end

	def destroy
		require_params params, false, :id
		@user.codes.destroy params[:id]
		redirect_to codes_path
	end

	def edit
		require_params params, false, :id
		@code = @user.codes.find params[:id]
		raise ClientException.new "Code not found!" if @code.nil?
	end

	def update
		require_params params, false, :id, :code
		require_params params[:code], false, :name
		@code = @user.codes.find params[:id]
		raise ClientException.new "Code not found!" if @code.nil?
		@code.set params[:code]
		redirect_to @code
	end
end
