module Judge
	module Interpreter
		def eval(name)
			name.strip!
			return @ram[name.delete("$").to_i] if name =~ /^\$/
			return @bios.constants[name.delete("!")].to_i if name =~ /^\!/
			name.to_i
		end

		def run(command, face_robot)
			return true unless Global::Permission[command.cmd][@level]
			self.send("_" + command.cmd, command.args, face_robot)
		end

		private

		def _nop(args, face_robot)
			true
		end

		def _die(args, face_robot)
			nil
		end

		def _move(args, face_robot)
			newx, newy = face_location
			if face_robot.nil?
				@x = newx
				@y = newy
			end
			true
		end

		def _turn(args, face_robot)
			t = eval(args[0])
			@face = (@face - 1) % 4 if t == 0
			@face = (@face + 1) % 4 if t == 1
			true
		end

		def _jump(args, face_robot)
			@seek = @segement.offset + args[0].to_i - 1
			true
		end

		def _trans(args, face_robot)
			unless face_robot.nil? || face_robot.power
				seg = @bios.find_segement(args[0])
				return if seg.nil?
				x = eval(args[1])
				face_robot.replace(@code[seg.offset..(seg.end - 1)], x)
			end
			true
		end

		def _create(args, face_robot)
			if face_robot.nil?
				level = eval(args[0])
				face_robot = copy(0, 0, rand(4), level)
			else
				true
			end
		end

		def _ecomp(args, face_robot)
			a1 = eval(args[0])
			a2 = eval(args[1])
			@seek += 1 unless a1 == a2
			true
		end

		def _scan(args, face_robot)
			return true unless args[0] =~ /^\$/
			x = args[0][1..-1].to_i
			return true if @ram[x].nil?
			if face_robot.nil?
				@ram[x] = 0
			else
				@ram[x] = if face_robot.team == @team then 2 else 1 end
			end
			true
		end

		def _say(args, face_robot)
			@output.say(@x, @y, "#{args[0..-1].join(" ")}") unless @output.nil?
			true
		end

		def _power(args, face_robot)
			x = eval(args[0])
			case x
			when 0
				@power = false
			when 1
				face_robot.power = false unless face_robot.nil?
			when 2
				face_robot.power = true unless face_robot.nil?
			end
			true
		end
	end
end
