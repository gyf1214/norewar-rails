module Judge
	class Match
		attr_reader :robots

		def initialize(output, codes)
			@map = Array.new(Global::MapSize) do
				Array.new(Global::MapSize, nil)
			end
			@robots = RobotQueue.new
			@lives = []
			@output = output
			@output.start
			codes.each_with_index do |c, index|
				x = rand(Global::MapSize)
				y = rand(Global::MapSize)
				face = rand(4)
				@output.push(x, y, index + 1, face)
				robot = Robot.new(x, y, face, index + 1, true)
				robot.bind @output
				robot.load_script(c)
				@robots.push(robot)
				@lives.push(robot)
				@map[x][y] = robot
			end
			@output.pop(0)
		end

		def next_frame
			return 0 if @robots.empty?
			next_delay, robot = @robots.fetch
			@output.start
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
						@output.push(oldx, oldy, 0, nil)
						@output.push(newx, newy, r.team, newface)
					end
					@output.push(oldx, oldy, nil, newface) unless newface == oldface
				when nil
					@lives.delete(@map[oldx][oldy])
					@map[oldx][oldy] = nil
					@output.push(oldx, oldy, 0, nil)
				else
					live.delay = next_delay
					@map[newx][newy] = live
					@map[newx][newy].x, @map[newx][newy].y = newx, newy
					@lives.push(live)
					@robots.push(r)
					@output.push(newx, newy, live.team, live.face)
				end
			end
			@output.pop(next_delay)
		end

		def calc
			ret = []
			@lives.each do |r|
				if ret[r.team].nil? then ret[r.team] = 1 else ret[r.team] += 1 end
			end
			cnt = 0
			t = -1
			ret.each_with_index do |i, k|
				if !i.nil? && i > 0
					cnt += 1
					t = k if ret[t] < ret[k] || t == -1
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
			end
			@output.finish win
			if !next_time.nil? && next_time <= Global::Timeout then win else -win end
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
