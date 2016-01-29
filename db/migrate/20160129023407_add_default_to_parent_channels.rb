class AddDefaultToParentChannels < ActiveRecord::Migration
  def change
  	remove_column :parent_channels, :defualt
  	add_column :parent_channels, :default, :boolean
  end
end
