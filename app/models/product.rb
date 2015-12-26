class Product < ActiveRecord::Base
	belongs_to :productqueue
	has_many :activities
end
