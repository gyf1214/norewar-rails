class Competitor
	include MongoMapper::EmbeddedDocument

	key :score, Integer
	key :user_id, ObjectId

	attr_accessible :score, :user_id

	def user
		User.find user_id
	end
end

class Contest
	include MongoMapper::Document

	key :name, String
	key :description, String
	many :competitors
	key :status, Integer
	key :round, Integer
	key :job_ids, Array
	many :jobs, in: :job_ids
	key :owner_id, ObjectId
	timestamps!

	STATUS_MSG = [
		'Open',
		'Going on',
		'Judging',
		'Ended'
	]

	def status_msg
		STATUS_MSG[status]
	end

	def rank
		competitors.sort do |i, j|
			j.score <=> i.score
		end
	end

	def next_round
		return if self.round <= 0
		self.round = self.round - 1
		competitors = rank
		count = competitors.size / 2
		count.times do |i|
			random = SecureRandom.hex 8
			com1 = competitors[2 * i].user
			com2 = competitors[2 * i + 1].user
			if com1.default.nil? || com2.default.nil?
				if com1.default.nil?
					competitors[2 * i].score -= 10
				else
					competitors[2 * i].score += 1
				end
				if com2.default.nil?
					competitors[2 * i + 1].score -= 10
				else
					competitors[2 * i + 1].score += 1
				end
			else
				self.status = 2
				puts self.status
				match_name = "#{name}-#{round}-#{com1.name}-vs-#{com2.name}-#{random}"
				match = Match.create name: match_name
				match.codes.push com1.default
				match.codes.push com2.default
				match.save
				jid = JudgeWorker.perform_in(1.seconds, match._id, _id)
				job = Job.create jid: jid, users: [com1._id, com2._id]
				puts job
				jobs.push job
			end
		end
		save
	end

	def joint?(user)
		competitors.each do |competitor|
			return true if user._id == competitor.user_id
		end
		false
	end

	def owner
		User.find owner_id
	end

	def admin?(user)
		user._id == owner_id
	end

	attr_accessible :name, :scores, :status, :competitors, :round, :owner_id, :description, :jobs
end
