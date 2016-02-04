class FixDefaultOnParentChannels < ActiveRecord::Migration
  def change
  	add_column :parent_channels, :default, :boolean
  end
end
