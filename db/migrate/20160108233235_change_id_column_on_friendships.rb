class ChangeIdColumnOnFriendships < ActiveRecord::Migration
  def change
  	change_column :friendships, :user_id, :string
  	change_column :friendships, :friend_id, :string
  end
end
