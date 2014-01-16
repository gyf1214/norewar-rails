require "./Robot"
require "./Output"
require "./RobotQueue"

module Judge
	class Match
		attr_reader :robots

		def initialize(name, competitors)
			@name = name
			@map = Array.new(Global::MapSize) do
				Array.new(Global::MapSize, nil)
			end
			@robots = RobotQueue.new
			@lives = []
			Output::init(@name)
			Output::start
			competitors.each_with_index do |c, index|
				x = rand(Global::MapSize)
				y = rand(Global::MapSize)
				face = rand(4)
				Output::push(x, y, index + 1, face)
				robot = Robot.new(x, y, face, index + 1, true)
				robot.load_script(c)
				@robots.push(robot)
				@lives.push(robot)
				@map[x][y] = robot
			end
			Output::pop(0)
		end

		def next_frame
			return 0 if @robots.empty?
			next_delay, robot = @robots.fetch
			Output::start
			robot.each do |r|
				next unless r.power
				oldx, oldy, oldface = r.x, r.y, r.face
				newx, newy = r.face_location
				face_robot = @map[newx][newy]
				face_power = face_robot.power
				live = r.next_command(face_robot)
				case live
				when true
					@robots.push(r) if r.power
					@robots.delete(face_robot) if !face_robot.power && face_power
					if face_robot.power && !face_power then
						face_robot.delay = next_delay
						face_robot.init
						@robots.push(face_robot) 
					end
					newx, newy, newface = r.x, r.y, r.face
					unless [oldx, oldy] == [newx, newy]
						@map[oldx][oldy] = nil
						@map[newx][newy] = r
						Output::push(oldx, oldy, 0, nil)
						Output::push(newx, newy, r.team, newface)
					end
					Output::push(oldx, oldy, nil, newface) unless newface == oldface
				when nil
					@lives.delete(@map[oldx][oldy])
					@map[oldx][oldy] = nil
					Output::push(oldx, oldy, 0, nil)
				else
					live.delay = next_delay
					@map[newx][newy] = live
					@map[newx][newy].x, @map[newx][newy].y = newx, newy
					@lives.push(live)
					@robots.push(r)
					Output::push(newx, newy, live.team, live.face)
				end
			end
			Output::pop(next_delay)
		end

		def calc
			ret = []
			@lives.each do |r|
				if ret[r.team].nil? then ret[r.team] = 1 else ret[r.team] += 1 end
			end
			cnt = 0
			t = 0
			ret.each_with_index do |i, k|
				if !i.nil? && i > 0
					cnt += 1
					t = k
				end
			end
			[cnt, t]
		end

		def next_time
			if @robots.empty? then nil else @robots.next end
		end

		def run
			win = 0
			while !next_time.nil? && next_time <= Global::Timeout
				next_frame
					cnt, win = calc
					break if cnt <= 1
					win = 0
				end
				Output::publish({:name => @name, :winner => win})
			end

		def print
			puts next_time
			Global::MapSize.times do |i|
				s = ""
				Global::MapSize.times do |j|
					s += if @map[i][j].nil? then "0" else @map[i][j].team.to_s end
				end
				puts s
			end
			puts
		end
	end
end
