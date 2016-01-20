class CreateParentChannels < ActiveRecord::Migration
  def change
    create_table :parent_channels do |t|

      t.timestamps null: false
    end
  end
end
