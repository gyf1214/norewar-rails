class WelcomeController < ApplicationController
	protect_from_forgery except: :event

	def index
		current_user
	end

	def error
	end

	def event
		job = Job.find_by_jid params[:jid]
		unless job.nil?
			job.users.each do |user|
				WebsocketRails.users[user].send_message :msg, JSON.parse(params[:msg])
			end
			job.destroy
		end
		redirect_to root_path
	end

	def test
		name = '3vtest2'
		user = User.find_by_name 'GYF'
		match = Match.find_by_name name
		match.destroy unless match.nil?
		match = Match.create name: name
		user.codes.each do |i|
			match.codes.push i
		end
		match.save
		jid = JudgeWorker.perform_async(match._id)
		Job.create jid: jid, users: [user._id]
		render nothing: true
	end
end
