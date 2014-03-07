class JudgeWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(id, contest_id = nil)
		match = Match.find id
		return if match.nil?
		@match = Judge::Match.new match
		Judge::Log::puts "Match #{match.name} start!"
		winner = @match.run
		Judge::Log::puts "Match #{match.name} finished"
		job = Job.find_by_jid jid
		contest = if contest_id.nil? then nil else Contest.find contest_id end
		unless contest.nil?
			contest.jobs.delete job
			contest.status = 1 if contest.jobs.empty?
			unless winner == 0
				for competitor in contest.competitors
					unless competitor.user.codes.find(match.codes[winner.abs - 1]._id).nil?
						competitor.score = competitor.score + if winner > 0 then 10 else 1 end
					end
				end
			end
			contest.save
		end
		job.destroy unless job.nil?
	end
end