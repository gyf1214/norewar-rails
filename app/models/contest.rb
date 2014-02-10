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
	many :competitors
	key :status, Integer
	key :round, Integer
	key :job_ids, Array
	many :jobs, in: :job_ids
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
			match_name = "#{name}-#{round}-#{com1.name}-vs-#{com2.name}-#{random}"
			match = Match.create name: match_name
			match.codes.push com1.default unless com1.default.nil?
			match.codes.push com2.default unless com2.default.nil?
			match.save
			jid = JudgeWorker.perform_in(3.seconds, match._id, _id)
			Job.create jid: jid, users: [com1._id, com2._id]
		end
		save
	end

	def joint?(user)
		competitors.each do |competitor|
			return true if user._id == competitor.user_id
		end
		false
	end

	attr_accessible :name, :scores, :status, :competitors, :round
end
