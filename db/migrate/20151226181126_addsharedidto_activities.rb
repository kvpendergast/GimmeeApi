class AddsharedidtoActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :shared_with_friend_activity_id, :integer
  end
end
