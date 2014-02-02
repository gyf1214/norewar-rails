class Code
	include MongoMapper::Document

	key :name, String
	key :code, String
	belongs_to :user

	timestamps!

	attr_accessible :name, :code
end
