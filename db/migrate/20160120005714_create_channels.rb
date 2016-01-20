class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.integer :queue_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
