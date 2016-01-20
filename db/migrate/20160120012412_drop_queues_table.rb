class DropQueuesTable < ActiveRecord::Migration
  def change
  	drop_table :queues
  end
end
