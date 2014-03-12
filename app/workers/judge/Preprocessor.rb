module Judge
	module Preprocessor
		def pre(line)
			if line =~ /^\#/
				@lines.delete line
			elsif line =~ /^\:/
				strs = line.split(' ')
				@constants[strs[0]] = strs[1]
				@lines.delete line
			elsif line =~ /^\@/
				@labels[line] = @lines.index line
				@lines.delete line
			end
		end

		def trans(name, offset)
			prefix = ''
			if name =~ /^\~/
				offset = 0
				prefix = '~'
				name.slice! 0
			end
			return prefix + @constants[name] if name =~ /^\:/
			return prefix + (@labels[name] - offset).to_s if name =~ /^\@/
			return prefix + name
		end

		def work(line, offset)
			cmd = Command.new line
			cmd.args.size.times do |i|
				cmd.args[i] = trans cmd.args[i], offset
			end
			@code.push cmd
		end

		def process(script)
			@labels = {}
			@constants = {}
			@lines = []

			script.each_line do |line|
				line = line.chomp.strip
				@lines.push line unless line.empty?
			end
			@lines.clone.each do |line|
				pre line
			end
			@lines.each_with_index do |line, index|
				work line, index
			end
		end
	end
end
