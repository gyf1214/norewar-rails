class ContestsController < ApplicationController
	def index
	end

	def new
		@contest = Contest.new
	end

	def create
		require_params params, false, :contest
		require_params params[:contest], false, :name
		limit = if params[:contest][:limit].nil? then 0 else params[:contest][:limit].to_i end
		Contest.create name: params[:contest][:name], limit: limit, status: 0	
		redirect_to contests_path
	end
end
