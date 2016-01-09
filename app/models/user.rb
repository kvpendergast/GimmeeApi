class User < ActiveRecord::Base

	scope :first_created, -> { order("created_at").first }
  	scope :last_created, -> { order("created_at DESC").first }

	has_one :productqueue
	has_many :activities

	has_many :friendships
	has_many :friends, :through => :friendships

	has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
	has_many :inverse_friends, :through => :inverse_friendships, :source => :user

	has_many :shared_activities
end
