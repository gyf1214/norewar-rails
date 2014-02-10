class JobsController < ApplicationController
	protect_from_forgery except: [:event, :delete]

	def event
		job = Job.find_by_jid params[:jid]
		unless job.nil?
			job.users.each do |user|
				WebsocketRails.users[user].send_message :msg, JSON.parse(params[:msg])
			end
		end
		redirect_to root_path
	end
end
