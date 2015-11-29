class AddsharedByToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :shared_by_id, :integer
  end
end
