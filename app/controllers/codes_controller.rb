class CodesController < ApplicationController
	before_action :current_user!

	def new
		@code = Code.new
		@code.code = ''
	end

	def create
		require_params params, false, :code
		require_params params[:code], false, :name
		require_params params[:code], true, :code
		code = @user.codes.create name: params[:code][:name], code: params[:code][:code]
		redirect_to code
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
		require_params params[:code], true, :code
		@code = @user.codes.find params[:id]
		raise ClientException.new "Code not found!" if @code.nil?
		@code.set params[:code]
		redirect_to @code
	end

	def upload
		@code = Code.new
		@code.code = ''
	end

	def file
		require_params params, false, :code
		require_params params[:code], false, :name
		require_params params[:code], true, :file
		file = params[:code][:file].read
		code = @user.codes.create name: params[:code][:name], code: file
		redirect_to code
	end
end
