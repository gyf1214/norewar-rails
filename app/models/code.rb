class Code
	include MongoMapper::Document

	key :name, String
	key :code, String
	belongs_to :user

	attr_accessible :name, :code
end
