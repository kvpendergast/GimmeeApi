class Product < ActiveRecord::Base
	belongs_to_many :users
end
