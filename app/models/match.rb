class Match
	include MongoMapper::Document

	key :name, String
	key :code_ids, Array
	many :codes, in: :code_ids
	key :user_ids, Array
	many :users, in: :user_ids
	key :status, Integer
	key :winner, Integer
	timestamps!

	STATUS_MSG = [
		'Judging',
		'Finished',
		'Error'
	]

	def status_msg
		STATUS_MSG[status]
	end

	def finished?
		status > 0
	end

	many :states do
		def around(after, before)
			where({:time.gte => after, :time.lte => before})
		end

		def at(time)
			where :time => time
		end

		def sort_time
			sort :time
		end

		def latest(time)
			before(time).sort_time.last
		end
	end

	attr_accessible :name, :codes, :states, :winner, :status
end
