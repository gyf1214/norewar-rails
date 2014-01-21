class State
	include MongoMapper::Document

	key :time, Integer
	key :say, Array
	key :delta, Array
	belongs_to :match

	attr_accessible :time, :say, :delta
end
