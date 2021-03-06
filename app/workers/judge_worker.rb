class JudgeWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(id, contest_id = nil)
		match = Match.find id
		return if match.nil?
		begin
			output = Judge::Output.new match
			codes = []
			match.code_ids.each do |c|
				code = Code.find c
				script = if code.nil? then "" else code.code end
				codes.push script
			end
			@match = Judge::Match.new output, codes
			Judge::Log::puts "Match #{match.name} start!"
			winner = @match.run
		rescue Exception => e
			Judge::Log::puts "Exception: #{e.message} while running: #{match.name}"
			Judge::Log::puts "At: #{e.backtrace[0]}"
			winner = 0
			match.status = 2
		end
		Judge::Log::puts "Match #{match.name} finished"
		match.status = 1 if match.status == 0
		match.save
		job = Job.find_by_jid jid
		contest = if contest_id.nil? then nil else Contest.find contest_id end
		unless contest.nil?
			contest.jobs.delete job
			if contest.jobs.empty?
				contest.status = if contest.round > 0 then 1 else 3 end
			end
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