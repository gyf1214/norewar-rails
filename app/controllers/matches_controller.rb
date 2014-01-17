class MatchesController < ApplicationController
	before_action :current_user!

	def index
		@matches = Hash.new
		@user.codes.each do |code|
			Match.where(code_ids: code._id).fields(:name).all.each do |match|
				@matches.store match._id, match
			end
		end
	end
end
