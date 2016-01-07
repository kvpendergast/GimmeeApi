class CreateUsers < ActiveRecord::Migration
  def change
    create_table :usersm id: :uuid do |t|
    	t.string :username
    	t.string :firstName
    	t.string :lastName
    	t.string :email
    	t.string :phone
    	t.timestamps
    end
  end
end
