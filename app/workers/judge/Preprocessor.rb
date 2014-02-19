module Judge
	module Preprocessor
		def line(line)
			line.chomp!
			line.strip!
			unless line == "" || line =~ /^\#/
				if line =~ /^\:/
					line.slice!(0)
					strs = line.split(" ");
					@bios.constants[strs[0]] = strs[1]
				elsif line =~ /^\@/
					line.slice!(0)
					@labels[line] = @offset - @segement.offset
				elsif line =~ /^\./
					line.slice!(0)
					strs = line.split(" ");
					unless @segement.nil?
						for i in (@segement.offset)..(@segement.end - 1)
							@code[i].args[0] = @labels[@code[i].args[0]] if @code[i].cmd == "jump"
						end
					end
					@segement = Segement.new(strs[0], @offset)
					@labels = {}
					@bios.segements.push(@segement)
				else
					@segement.end += 1
					@code.push(Command.new(line))
					@offset += 1
				end
			end
		end

		def process(script)
			@offset = 0
			script.each_line do |line|
				line(line)
			end
			unless @segement.nil?
				for i in (@segement.offset)..(@segement.end - 1)
					@code[i].args[0] = @labels[@code[i].args[0]] if @code[i].cmd == "jump"
				end
			end
		end
	end
end
