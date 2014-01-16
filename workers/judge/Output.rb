require "json"
require "./Config"

module Judge
	module Output
		def self.fetch(competitors)
			ret = []
			competitors.each do |c|
				ret.push(@redis[Global::CODE_PREFIX + c])
			end
			ret
		end

		def self.init(name)
			@name = Global::OUT_PREFIX + name
			@redis.del(@name)
		end

		def self.start
			@ret = []
			@say = []
			@map = Array.new(16) do
				Array.new(16, nil)
			end
		end

		def self.say(x, y, sth)
			@say.push({:x => x, :y => y, :say => sth})
		end

		def self.push(x, y, delta, face)
			@ret.delete(@map[x][y])
			@map[x][y] = {:x => x, :y => y}
			@map[x][y][:delta] = delta unless delta.nil?
			@map[x][y][:face] = face unless face.nil?
			@ret.push(@map[x][y])
		end

		def self.pop(time)
			raise "time not increase on #{time}!" unless @redis.zrangebyscore(@name, time, time).empty?
			@redis.zadd(@name, time, {:time => time, :map => @ret, :say => @say}.to_json) unless @ret.empty? && @say.empty?
		end

		def self.publish(msg)
			@topic.publish(msg.to_json, :routing_key => Global::BUNNY_OUT)
		end
	end
end
