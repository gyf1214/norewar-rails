class Comment
	include MongoMapper::EmbeddedDocument

	key :user_id, ObjectId
	key :content, String

	def user
		User.find user_id
	end
end
