class WelcomeController < ApplicationController
	def index
	end

	def error
	end

	def test
		user = User.find_by_name 'GYF'
		match = Match.find_by_name '3vtest'
		match.destroy
		match = Match.create name: '3vtest'
		user.codes.each do |i|
			match.codes.push i
		end
		match.save
		JudgeWorker.new.perform match._id
		render nothing: true
	end
end
