class RenameProductqueuesToQueues < ActiveRecord::Migration
  def change
  	rename_table :productqueues, :queues
  end
end
