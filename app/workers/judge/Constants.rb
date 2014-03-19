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

module Judge
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

		Delay		= {
			"move"		=> 10,
			"jump"		=> 1,
			"turn"		=> 5,
			"die"		=> 100,
			"nop"		=> 100,
			"scan"		=> 20,
			"ecomp"		=> 2,
			"say"		=> 1,
			"power"		=> 10,
			"set"		=> 1,
			"inc"		=> 1,
			"dec"		=> 1,
		}

		Permission = {
			"move"		=> [false, true, true, true],
			"jump"		=> [true, true, true, true],
			"turn"		=> [true, true, true, true],
			"die"		=> [true, true, true, true],
			"nop"		=> [true, true, true, true],
			"say"		=> [true, true, true, true],
			"power"		=> [false, true, true, true],
			"trans"		=> [false, true, true, true],
			"ecomp"		=> [false, false, true, true],
			"scan"		=> [false, false, true, true],
			"create"	=> [false, false, false, true],
			"set"		=> [true, true, true, true],
			"inc"		=> [true, true, true, true],
			"dec"		=> [true, true, true, true]
		}
	end
end