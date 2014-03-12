module Judge
	class Command
		attr_accessor :cmd
		attr_accessor :args

		def initialize(str)
			strs = str.strip.split(" ")
			@cmd = strs[0]
			@args = strs.slice(1, strs.size - 1)
		end

		def to_s
			@cmd + ' ' + @args.join(' ')
		end
	end

	class Code
		def initialize()
			@data = []
		end

		def [](index)
			@data[index]
		end

		def []=(index, val)
			@date[index] = val
		end

		def push(cmd)
			@data.push(cmd)
		end

		def each
			@data.each do |i|
				yield i
			end
		end

		def replace(codes, offset)
			return if codes.nil?
			codes.each do |cmd|
				@data[offset] = cmd.clone
				offset += 1
			end
		end

		def clone
			ret = Code.new
			each do |i|
				ret.push(i.clone)	
			end
			ret
		end
	end
end
