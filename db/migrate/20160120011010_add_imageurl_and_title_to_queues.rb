class AddImageurlAndTitleToQueues < ActiveRecord::Migration
  def change
  	add_column :queues, :image_url, :string
  	add_column :queues, :title, :string 
  end
end
