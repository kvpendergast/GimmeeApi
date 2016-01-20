class UpdateActivitiesFields < ActiveRecord::Migration
  def change
  	remove_column :activities, :purchased
  	add_column :activities, :gimmee, :boolean

  	add_column :activities, :like, :boolean

  	remove_column :activities, :viewTime
  	add_column :activities, :view_time, :float
  end
end
