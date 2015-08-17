class AddColumnsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :productName, :string
    add_column :activities, :price, :string
    add_column :activities, :imageurl, :text
    add_column :activities, :externalid, :string
    add_column :activities, :detailPageUrl, :string
  end
end
