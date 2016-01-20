class ChangeFieldsOnActivities < ActiveRecord::Migration
  def change
  	remove_column :activities, :user_id

  	add_column :activities, :channel_id, :integer
  	add_column :activities, :user_id, :uuid

  	
  	remove_column :activities, :productName
	remove_column :activities, :price
	remove_column :activities, :imageurl
	remove_column :activities, :externalid
	remove_column :activities, :detailPageUrl
	remove_column :activities, :supplier_id

  end
end
