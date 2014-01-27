class WelcomeController < ApplicationController
	def index
		current_user
	end

	def error
	end

	def test
		random = SecureRandom.hex 8
		name = "3vtest-#{random}"
		user = User.find_by_name 'GYF'
		match = Match.create name: name
		user.codes.each do |i|
			match.codes.push i
		end
		match.save
		jid = JudgeWorker.perform_async(match._id)
		Job.create jid: jid, users: [user._id]
		render nothing: true
	end

	def clear
		MongoMapper.database['states'].remove
		MongoMapper.database['matches'].remove
		render nothing: true
	end
end
