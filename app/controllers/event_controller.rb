class EventController < WebsocketRails::BaseController
	protected
	def client_error(err)
		trigger_failure error: err.message
	end
end