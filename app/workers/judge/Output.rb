module Judge
	class Output
		def initialize(match)
			@match = match
			@time = -1
			@buffer = Array.new
		end
		
		def start
			@ret = []
			@say = []
			@map = Array.new(16) do
				Array.new(16, nil)
			end
		end

		def say(x, y, sth)
			@say.push({x: x, y: y, say: sth})
		end

		def push(x, y, delta, face)
			@ret.delete(@map[x][y])
			@map[x][y] = {x: x, y: y}
			@map[x][y][:delta] = delta unless delta.nil?
			@map[x][y][:face] = face unless face.nil?
			@ret.push(@map[x][y])
		end

		def pop(time)
			raise "Time not increase!" unless time > @time
			@time = time
			@buffer.push time: @time, delta: @ret, say: @say, match_id: @match._id
		end

		def finish(winner)
			MongoMapper.database['states'].insert @buffer
			@match.winner = winner
			@match.save
		end
	end
end
