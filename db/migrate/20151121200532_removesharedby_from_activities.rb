class RemovesharedbyFromActivities < ActiveRecord::Migration
  def change
  	remove_column :activities, :shared_by_id
  end
end
