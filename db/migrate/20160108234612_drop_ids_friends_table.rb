class DropIdsFriendsTable < ActiveRecord::Migration
  def change
  	remove_column :friendships, :user_id
  	remove_column :friendships, :friend_id
  end
end
