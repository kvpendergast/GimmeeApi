class ChangeUserIdOnChannelsToUuid < ActiveRecord::Migration
  def change
  	remove_column :channels, :user_id
  	add_column :channels, :user_id, :uuid
  end
end
