class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :productName
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
