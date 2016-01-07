class RenamesharedIdOnActivities < ActiveRecord::Migration
  def change
  	rename_column :activities, :shared_with_friend_activity_id, :shared_activity_id
  end
end
