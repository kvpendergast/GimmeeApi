class AddTagToProductqueues < ActiveRecord::Migration
  def change
    add_column :productqueues, :tag, :string
  end
end
