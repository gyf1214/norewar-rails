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
		require_code
	end

	def index
		@codes = @user.codes
	end

	def destroy
		require_code
		@code.destroy

		redirect_to codes_path
	end

	def edit
		require_code
	end

	def update
		require_params params, false, :code
		require_params params[:code], false, :name
		require_params params[:code], true, :code
		require_code

		@code.name = params[:code][:name]
		@code.code = params[:code][:code]
		@code.save
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

	def default
		require_code

		@user.set default_id: params[:id]
		@code.save
		redirect_to @code
	end

	private

	def require_code
		require_params params, false, :id
		@code = @user.codes.find params[:id]
		raise ClientException.new "Code not found!" if @code.nil?
	end
end
