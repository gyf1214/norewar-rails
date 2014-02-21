class State
	include MongoMapper::Document

	key :time, Integer
	key :say, Array
	key :delta, Array
	belongs_to :match

	ensure_index :match_id
	ensure_index :time

	attr_accessible :time, :say, :delta, :match_id
end
