class User
	include MongoMapper::Document

	key :name,		String
	key :password,	String
	key :session,	String
	many :codes
	key :default_id, ObjectId

	def default
		codes.find default_id
	end

	attr_accessible :name, :password, :codes, :session, :default_id
end
