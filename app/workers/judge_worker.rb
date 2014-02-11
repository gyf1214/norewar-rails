class JudgeWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(id, contest_id = nil)
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(msg: 'start')
		match = Match.find id
		return if match.nil?
		@match = Judge::Match.new match
		Judge::Log::puts "Match #{match.name} start!"
		winner = @match.run
		Judge::Log::puts "Match #{match.name} finished"
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(msg: 'finish')
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(winner: winner)
		job = Job.find_by_jid jid
		job.destroy unless job.nil?
		contest = if contest_id.nil? then nil else Contest.find contest_id end
		unless winner == 0 || contest.nil?
			for competitor in contest.competitors
				unless competitor.user.codes.find(match.codes[winner - 1]._id).nil?
					competitor.score = competitor.score + 1
				end
			end
			contest.save
		end
	end
end