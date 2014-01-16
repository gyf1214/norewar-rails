module Judge
	class Segement
		attr_accessor :name
		attr_accessor :offset
		attr_accessor :end

		def initialize(name, offset)
			@name = name
			@offset = offset
			@end = offset
		end
	end

	class Bios
		attr_reader :constants
		attr_reader :segements

		def initialize(constants = {}, segements = [])
			@constants = constants
			@segements = segements
		end

		def find_segement(name)
			return segements[name.to_i] if name.to_i.to_s == name
			ret = nil
			segements.each do |s|
				ret = s if s.name == name
			end
			ret
		end
	end
end
