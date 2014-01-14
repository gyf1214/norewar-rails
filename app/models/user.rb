class User
	include MongoMapper::Document

	key :name,		String
	key :password,	String
	many :codes

	attr_accessible :name, :password
end
