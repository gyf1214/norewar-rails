require "algorithms"

module Judge
	class RobotQueue
		def initialize()
			@data = Containers::RBTreeMap.new
		end

		def push(robot)
			key = robot.delay
			if @data.has_key?(key)
				@data[key].push(robot)
			else
				@data[key] = [robot]
			end
		end

		def fetch
			t = @data.min_key
			ret = @data.delete_min.sort do |a, b|
				a.level <=> b.level
			end
			[t, ret]
		end

		def delete(robot)
			val = @data[robot.delay]
			val.delete(robot) unless val.nil?
		end

		def empty?
			@data.empty?
		end

		def next
			@data.min_key
		end

		def each
			@data.each do |i, k|
				yield i, k
			end
		end
	end
end
