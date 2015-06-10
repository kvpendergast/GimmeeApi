class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :supplierName

      t.timestamps null: false
    end
  end
end
