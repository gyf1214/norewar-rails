class MatchesController < ApplicationController
	before_action :current_user!

	def index
		@matches = Hash.new
		Match.where(user_ids: @user._id)
			 .sort(:updated_at.desc)
			 .fields(:name, :winner, :status, :created_at, :updated_at).all.each do |match|
			@matches.store match._id, match
		end
	end

	def show
		require_params params, false, :id
		@match = Match.find params[:id]
		raise ClientException.new "Match not found!" if @match.nil?
		@codes = []
		@match.users.each_with_index do |user, i|
			code = Code.find @match.code_ids[i]
			code_name = if code.nil? then '[Deleted]' else code.name end
			@codes.push user: user.name, name: code_name
		end
	end

	def view
		require_params params, false, :id, :after, :before
		@match = Match.find params[:id]
		raise ClientException.new "Match not found!" if @match.nil?
		raise ClientException.new "Match still judging!" unless @match.finished?
		ret = @match.states.where(:time.gt => params[:after].to_i)
		.where(:time.lte => params[:before].to_i).sort(:time).all
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
