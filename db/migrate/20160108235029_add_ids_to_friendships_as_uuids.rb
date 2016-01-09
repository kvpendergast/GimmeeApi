class AddIdsToFriendshipsAsUuids < ActiveRecord::Migration
  def change
  	add_column :friendships, :user_id, :uuid
  	add_column :friendships, :friend_id, :uuid
  	
  end
end
