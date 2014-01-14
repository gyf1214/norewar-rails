require "json"
require "bunny"
require "redis"
require "./Output"
require "./Match"
require "./Log"

module Judge
	def self.init
		Log::puts "Connecting to Bunny"
		Output::connect_bunny do |msg|
			subscribe(msg)
		end
		Log::puts "Done"
		Log::puts "Connecting to Redis"
		Output::connect_redis
		Log::puts "Done"
	end

	def self.main
		Log::puts "Judge Starting..."
		init
		Log::puts "All Done. Wait for message..."
		sleep
	end

	def self.dispose
		Log::puts "Judge Stopping..."
		Log::puts "Close Bunny"
		Output::dispose
		Log::puts "Done"
		Log::puts "All Done. Exit"
	end

	def self.subscribe(msg)
		begin
			msg = JSON.parse(msg)
			m = Match.new(msg["name"], Output::fetch(msg["competitors"]))
			Log::puts "New match \"#{msg["name"]}\" started"
			m.run
			Log::puts "Match \"#{msg["name"]}\" ended"
		rescue
			Log::error "#{$!} at: #{$@[0]}"
		end
	end
end
