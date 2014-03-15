module Judge
	module Interpreter
		def eval(name)
			name = name.clone
			name.strip!
			name.slice!(0) if name =~ /^\~/
			return @ram[name.delete("$").to_i] if name =~ /^\$/
			name.to_i
		end

		def eval_var(name)
			name = name.clone
			return nil unless name =~ /^\$/
			x = name[1..-1].to_i
			return nil if @ram[x].nil?
			x
		end

		def eval_label(name)
			name = name.clone
			ans = eval(name)
			if name =~ /^\~/ then ans else ans + @seek end
		end

		def eval_delay(cmd)
			return Global::Delay['nop'] if cmd.nil?
			if cmd.cmd == 'create'
				x = eval(cmd.args[0])
				x * x * 10 + 20
			elsif cmd.cmd == 'trans'
				x = eval_label(cmd.args[0])
				y = eval_label(cmd.args[1])
				10 * (Math.log(y - x, 2).ceil + 1)
			else
				Global::Delay[cmd.cmd]
			end
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
			@seek = eval_label(args[0]) - 1
			true
		end

		def _trans(args, face_robot)
			unless face_robot.nil? || face_robot.power
				x = eval_label(args[0])
				y = eval_label(args[1])
				z = eval_label(args[2])
				face_robot.replace(@code[x..(y - 1)], z)
			end
			true
		end

		def _create(args, face_robot)
			if face_robot.nil?
				level = eval(args[0])
				face_robot = copy(0, 0, level)
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
			x = eval_var(args[0])
			return if x.nil?
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

		def _set(args, face_robot)
			x = eval_var(args[0])
			y = eval(args[1])
			@ram[x] = y unless x.nil?
			true
		end

		def _inc(args, face_robot)
			x = eval_var(args[0])
			@ram[x] = @ram[x] + 1 unless x.nil?
			true
		end

		def _dec(args, face_robot)
			x = eval_var(args[0])
			@ram[x] = @ram[x] - 1 unless x.nil?
			true
		end
	end
end
