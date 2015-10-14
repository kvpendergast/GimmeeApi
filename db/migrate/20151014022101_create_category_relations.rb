class CreateCategoryRelations < ActiveRecord::Migration
  def change
    create_table :category_relations do |t|

      t.timestamps null: false
    end
  end
end
