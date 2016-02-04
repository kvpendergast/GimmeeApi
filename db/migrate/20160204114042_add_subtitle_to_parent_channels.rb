class AddSubtitleToParentChannels < ActiveRecord::Migration
  def change
    add_column :parent_channels, :subtitle, :string
  end
end
