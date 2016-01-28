class AddChannelViewCountToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :channel_view_count, :integer
  end
end
