class AddSupplierIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :supplier_id, :integer
  end
end
