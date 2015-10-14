class CategoryRelation < ActiveRecord::Base
	belongs_to :category
	belongs_to :child, :class_name => 'category'
end
