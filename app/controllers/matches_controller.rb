class MatchesController < ApplicationController
	before_action :current_user!

	def index
		@matches = Hash.new
		@user.codes.each do |code|
			Match.where(code_ids: code._id).fields(:name, :winner, :created_at, :updated_at).all.each do |match|
				@matches.store match._id, match
			end
		end
	end

	def show
		require_params params, false, :id
		@match = Match.find params[:id]
		raise ClientException.new "Match not found!" if @match.nil?
	end

	def view
		require_params params, false, :id, :after, :before
		@match = Match.find params[:id]
		raise ClientException.new "Match not found!" if @match.nil?
		raise ClientException.new "Match still judging!" unless @match.finished?
		ret = @match.states.where(:time.gt => params[:after].to_i)
		.where(:time.lte => params[:before].to_i).all
		respond_to do |format|
			format.html do
				render json: ret
			end
			format.xml do
				render xml: ret
			end
			format.json do
				render json: ret
			end
		end
	end
end
