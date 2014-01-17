class User
	include MongoMapper::Document

	key :name,		String
	key :password,	String
	key :session,	String
	many :codes

	attr_accessible :name, :password, :code, :session
end
