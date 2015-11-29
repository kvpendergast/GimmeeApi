class SharedActivity < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, :class_name => 'User'
	belongs_to :activity
	belongs_to :new_activity, :class_name => 'Activity'
end
