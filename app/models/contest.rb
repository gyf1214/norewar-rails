class Competitor
	include MongoMapper::EmbeddedDocument

	key :score, Integer
	one :user

	attr_accessible :score, :user
end

class Contest
	include MongoMapper::Document

	key :name, String
	many :competitors
	key :status, Integer
	key :limit, Integer
	timestamps!

	STATUS_MSG = [
		'Open',
		'Going on',
		'Ended'
	]

	def status_msg
		STATUS_MSG[status]
	end

	def rank
		competitors.sort :score.desc
	end

	attr_accessible :name, :scores, :status, :competitors, :limit
end
