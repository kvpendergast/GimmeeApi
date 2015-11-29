class CreateSharedActivities < ActiveRecord::Migration
  def change
    create_table :shared_activities do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :friend_id

      t.timestamps null: false
    end
  end
end
