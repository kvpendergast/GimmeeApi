class AddInitiatedFriendshipToFriendships < ActiveRecord::Migration
  def change
    add_column :friendships, :initiated_friendship, :boolean
  end
end
