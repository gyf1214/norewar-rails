module ApplicationHelper
	class ClientException < Exception
		attr_reader :message

		def initialize(message)
			@message = message
		end
	end
end
