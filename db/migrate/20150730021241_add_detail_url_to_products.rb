class AddDetailUrlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :detailPageUrl, :string
  end
end
