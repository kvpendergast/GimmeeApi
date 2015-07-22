class AddexternalIdToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :externalId, :string
  end
end
