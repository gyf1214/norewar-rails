class Match
	include MongoMapper::Document

	key :name, String
	key :code_ids, Array
	many :codes, in: :code_ids
	key :winner, Integer

	many :states do
		def before(time)
			where :time.lte => time
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

	attr_accessible :name, :codes, :states, :winner
end
