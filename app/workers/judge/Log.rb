#require "logger"

module Judge
	#sothing here
=begin
	module Log
		@log = Logger.new(STDOUT)
		@err = Logger.new(STDERR)

		@log.datetime_format = "%Y-%m-%d %H:%M:%S"
		@err.datetime_format = "%Y-%m-%d %H:%M:%S"
		@log.formatter = @err.formatter = proc do |s, d, h, m|
			"[#{d}]: #{m}\n"
		end

		def self.puts(sth)
			@log.info(sth)
		end

		def self.error(sth)
			@err.error(sth)
		end
	end
=end
	module Log
		def self.puts(sth)
			STDOUT.puts sth
		end

		def self.error(sth)
			STDERR.puts sth
		end
	end
end
