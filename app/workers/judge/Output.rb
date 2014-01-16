require "json"

module Judge
	module Output
		def self.init(match)
			@match = match
			@time = -1
		end
		def self.start
			@ret = []
			@say = []
			@map = Array.new(16) do
				Array.new(16, nil)
			end
		end

		def self.say(x, y, sth)
			@say.push({x: x, y: y, say: sth})
		end

		def self.push(x, y, delta, face)
			@ret.delete(@map[x][y])
			@map[x][y] = {x: x, y: y}
			@map[x][y][:delta] = delta unless delta.nil?
			@map[x][y][:face] = face unless face.nil?
			@ret.push(@map[x][y])
		end

		def self.pop(time)
			raise "Time not increase!" unless time > @time
			@time = time
			@match.states.push time: @time, delta: @ret, say: @say
			@match.save
		end

		def self.finish(winner)
			@match.winner = winner
			@match.save
		end
	end
end
