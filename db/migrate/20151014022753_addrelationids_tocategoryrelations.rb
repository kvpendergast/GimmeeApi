class AddrelationidsTocategoryrelations < ActiveRecord::Migration
  def change
  	add_column :category_relations, :parent_id, :integer
    add_column :category_relations, :child_id, :integer
  end
end
