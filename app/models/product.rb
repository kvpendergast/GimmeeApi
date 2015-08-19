class Product < ActiveRecord::Base
	#validations
	#validates :supplier_id, presence: true

	#relations
	#belongs_to :supplier
	belongs_to :productqueue
	has_many :activities
end
