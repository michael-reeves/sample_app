class Micropost < ActiveRecord::Base
	# create a relationship between users and microposts
	belongs_to :user  		# foreign key - user_id
	# create a DESC (newest to oldest) order for the posts
	default_scope -> { order( 'created_at DESC' ) }   # note the stabby lambda syntax
	
	# validations
	validates :content, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

end
