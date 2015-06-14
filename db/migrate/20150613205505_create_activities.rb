class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.integer :product_id
      t.boolean :purchased
      t.float :viewTime
      t.decimal precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end
