class Channel < ActiveRecord::Base
	belongs_to :queue
	has_many :activities
end
