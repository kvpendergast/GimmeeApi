class SharedActivity < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => 'User'
	belongs_to :activity
	has_many :shared_with_friend_activities, :class_name => 'Activity'
end
