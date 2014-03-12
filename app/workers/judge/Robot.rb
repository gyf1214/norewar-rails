module Judge
	class Robot
		attr_accessor :x
		attr_accessor :y
		attr_accessor :face
		attr_accessor :level
		attr_accessor :delay
		attr_accessor :team
		attr_accessor :power

		include Interpreter

		def initialize(x, y, face, team, power = false, level = Global::Creature, code = Code.new)
			@x = x
			@y = y
			@face = face
			@team = team
			@level = level
			@code = code
			@power = power
			@ram = Array.new(Global::RamSize, 0)
			@delay = 0
			@seek = 0
		end

		def load_script(script)
			self.extend(Preprocessor)
			process(script)
			init
		end

		def init
			@seek = 0
			@delay += Global::Delay(@code[@seek])
		end

		def copy(x, y, level, power = false)
			Robot.new(x, y, @face, @team, power, level, Code.new)
		end

		def face_location
			[(@x + Global::Movex[@face]) % Global::MapSize, (@y + Global::Movey[@face]) % Global::MapSize]
		end

		def next_command(face_robot)
			cmd = @code[@seek]
			cmd = Command.new("die") if cmd.nil?
			ret = run(cmd, face_robot)
			@seek += 1
			@delay += Global::Delay(@code[@seek])
			ret
		end

		def replace(codes, offset)
			@code.replace(codes, offset)
		end

		def bind(output)
			@output = output
		end
	end
end