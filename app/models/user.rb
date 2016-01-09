class User < ActiveRecord::Base
	validates_uniqueness_of :username, :case_sensitive => false, :allow_blank => true, :allow_null => true, :allow_nil => true
	validates_uniqueness_of :email, :case_sensitive => false, :allow_blank => true, :allow_null => true, :allow_nil => true
	validates_uniqueness_of :phone, :case_sensitive => false, :allow_blank => true, :allow_null => true, :allow_nil => true
	validates_uniqueness_of :facebook_id, :case_sensitive => false, :allow_blank => true, :allow_null => true, :allow_nil => true

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
