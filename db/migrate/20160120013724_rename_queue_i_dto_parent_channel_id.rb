class RenameQueueIDtoParentChannelId < ActiveRecord::Migration
  def change
  	remove_column :channels, :queue_id
  	add_column :channels, :parent_channel_id, :integer
  end
end
