class DeleteAgeRangeFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :age_range
  	add_column :users, :age_min, :string
  	add_column :users, :age_max, :string
  end
end
