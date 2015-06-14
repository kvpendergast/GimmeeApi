class Activity < ActiveRecord::Base
	#validations
	validates :product_id, :user_id, presence: true

	#relations
	belongs_to :user
	belongs_to :product

end
