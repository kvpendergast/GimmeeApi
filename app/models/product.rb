class Product < ActiveRecord::Base
	#validations
	validates :supplier_id, presence: true

	#relations
	belongs_to :supplier
	has_many :activities
end
