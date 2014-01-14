class NilClass
	def team
		0
	end

	def cmd
		"nop"
	end

	def args
		nil
	end

	def power
		false
	end

	def clone
		nil
	end

	def []
		nil
	end
end

module Global
	Wood		= 0
	Fighter		= 1
	Senior		= 2
	Creature	= 3

	Movex		= [0, -1, 0, 1]
	Movey		= [1, 0, -1, 0]

	RamSize		= 20
	MapSize		= 16
	Timeout		= 65536

	def self.Delay(cmd)
		map = {
			"move"		=> 10,
			"jump"		=> 1,
			"turn"		=> 5,
			"die"		=> 100,
			"nop"		=> 100,
			"create"	=> 20,
			"trans"		=> 40,
			"scan"		=> 20,
			"ecomp"		=> 2,
			"say"		=> 1,
			"power"		=> 10
		}
		return map["nop"] if cmd.nil?
		ret = if map[cmd.cmd].nil? then 0 else map[cmd.cmd] end
		ret += cmd.args[0].to_i * cmd.args[0].to_i * 10 if cmd.cmd == "create"
		ret
	end

	Permission = {
		"move"		=> [true, true, true, true],
		"jump"		=> [true, true, true, true],
		"turn"		=> [true, true, true, true],
		"die"		=> [true, true, true, true],
		"nop"		=> [true, true, true, true],
		"say"		=> [true, true, true, true],
		"power"		=> [false, true, true, true],
		"trans"		=> [false, true, true, true],
		"ecomp"		=> [false, false, true, true],
		"scan"		=> [false, false, true, true],
		"create"	=> [false, false, false, true]
	}
end