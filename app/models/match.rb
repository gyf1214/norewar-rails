class Match
	include MongoMapper::Document

	key :name, String
	key :code_ids, Array
	many :codes, in: :code_ids
	key :states, Array
	key :winner, Integer

	attr_accessible :name, :codes, :states, :winner
end
