class RemoveUserIdAndProductIdFromProductQeueues < ActiveRecord::Migration
  def change
  	remove_column :productqueues, :productids
  	remove_column :productqueues, :user_id
  end
end
