require "fileutils"
require "./Judge"
require "./Config"

module Controller
	def self.store(pid)
		File.open(Global::PID_FILE, "w") do |file|
			file << pid
		end
	end

	def self.recall
		ret = nil
		File.foreach(Global::PID_FILE) do |line|
			ret = line.strip
		end
		ret
	end

	def self.remove
		FileUtils.rm(Global::PID_FILE)
	end

	def self.start
		puts "Starting judge..."
		if File.exist?(Global::PID_FILE)
			puts "[Failed]"
			puts "Judge already started. Please check your pid file."
			exit
		end
		FileUtils::mkdir_p(Global::LOG_PATH)
		log_file = Global::LOG_PATH + Global::LOG_FILE
		err_file = Global::LOG_PATH + Global::ERR_FILE
		log = File.new(log_file, "a")
		err = File.new(err_file, "a")
		log.chown(Global::USER_ID, Global::GROUP_ID)
		err.chown(Global::USER_ID, Global::GROUP_ID)
		Process.fork do
			exit if fork
			store(Process.pid)
			Process.uid = Global::USER_ID
			Process.gid = Global::GROUP_ID
			Process.euid = Global::USER_ID
			Process.egid = Global::GROUP_ID
			Process.setsid
			File.umask(0000)
			STDIN.reopen(Global::NULL_FILE)
			STDOUT.reopen(log_file, "a")
			STDERR.reopen(err_file, "a")
			STDOUT.sync = true
			STDERR.sync = true
			Signal.trap "TERM" do
				Judge::dispose
				exit
			end
			Judge::main
		end
		puts "[OK]"
	end

	def self.stop
		puts "Stopping judge..."
		if !File.exist?(Global::PID_FILE)
			puts "[Failed]"
			puts "PID file not found. Are your sure the background process is running?"
			exit
		end
		pid = recall
		remove
		pid && Process.kill("TERM", pid.to_i)
		puts "[OK]"
	end

	def self.control(cmd)
		case cmd
		when "start"
			start
		when "stop"
			stop
		when "restart"
			stop
			start
		else
			puts "Invalid command"
			puts "Usage: ruby Controller.rb {start | stop | restart}"
			exit
		end
	end
end

Controller::control(ARGV[0])
