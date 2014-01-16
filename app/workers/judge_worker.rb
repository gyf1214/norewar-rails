require 'judge/Bios'
require 'judge/Code'
require 'judge/Constants'
require 'judge/Interpreter'
require 'judge/Log'
require 'judge/Match'
require 'judge/Output'
require 'judge/Preprocessor'
require 'judge/Robot'
require 'judge/RobotQueue'

class JudgeWorker
	#include Sidekiq::Worker
	#sidekiq_options :retry => false

	def perform(id)
		match = Match.find id
		return if match.nil?
		@match = Judge::Match.new match
		Judge::Log::puts "Match #{match.name} start!"
		@match.run
		Judge::Log::puts "Match #{match.name} finished"
	end
end