class CreateProductqueues < ActiveRecord::Migration
  def change
    create_table :productqueues do |t|
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
