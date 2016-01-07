class AddUsers < ActiveRecord::Migration
  def change
   create_table :users, id: :uuid  do |t|
      t.string :username
      t.string :firstName
      t.string :lastName
      t.string :email
      t.string :phone
      t.string :facebook_id
      t.string :encrypted_password
      t.timestamps
    end
  end
end
