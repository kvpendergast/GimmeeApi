class AddProductIdsToProductqueues < ActiveRecord::Migration
  def change
  	add_column :productqueues, :productids, :integer, array: true, default: []
  end
end
