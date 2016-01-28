class AddTitleAndImageUrlToParentChannel < ActiveRecord::Migration
  def change
  	add_column :parent_channels, :title, :string
  	add_column :parent_channels, :image_url, :string
  	add_column :parent_channels, :tags, :string
  end
end
