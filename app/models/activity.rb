class Activity < ActiveRecord::Base
  #validations
  validates :product_id, :user_id, presence: true

  #relations
  belongs_to :user
  belongs_to :product
  belongs_to :channel
  has_many :shared_activities
  belongs_to :shared_with_friend_activity, :class_name => 'shared_activities'
end
