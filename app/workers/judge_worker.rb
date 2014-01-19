=begin
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
=end

class JudgeWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false

	def perform(id)
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(msg: 'start')
		match = Match.find id
		return if match.nil?
		@match = Judge::Match.new match
		Judge::Log::puts "Match #{match.name} start!"
		winner = @match.run
		Judge::Log::puts "Match #{match.name} finished"
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(msg: 'finish')
		Curl.post 'http://localhost:3000/event', jid: jid, msg: JSON.dump(winner: winner)
		Curl.delete 'http://localhost:3000/event', jid: jid
	end
end