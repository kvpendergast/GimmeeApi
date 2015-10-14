class AddCategoryNameToCategoriesController < ActiveRecord::Migration
  def change
    add_column :categories, :category_name, :string
    add_column :categories, :category_id, :integer
  end
end
