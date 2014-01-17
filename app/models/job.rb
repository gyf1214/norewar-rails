class Job
	include MongoMapper::Document

	key :jid, String
	key :users, Array

	ensure_index :jid

	attr_accessible :jid, :users
end
