class Channel < ActiveRecord::Base
	belongs_to :parent_channel
	has_many :activities
end
