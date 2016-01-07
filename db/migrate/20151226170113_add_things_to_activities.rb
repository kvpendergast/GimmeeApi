class AddThingsToActivities < ActiveRecord::Migration
  def change
  	add_column :shared_activities, :activity_id, :integer
  end
end
