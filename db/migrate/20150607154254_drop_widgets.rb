class DropWidgets < ActiveRecord::Migration
  def change
  	drop_table :widgets
  end
end
