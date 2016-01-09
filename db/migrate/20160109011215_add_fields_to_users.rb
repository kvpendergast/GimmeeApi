class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :facebookAccessToken, :string
  	add_column :users, :gender, :string
  	add_column :users, :locale, :string
  	add_column :users, :timezone, :string
  	add_column :users, :age_range, :string
  end
end
