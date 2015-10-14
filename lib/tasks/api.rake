namespace :amazon do
  desc "Simple cron job placeholder. Eventually will put product upsert algorithm here?"
  task upsert_products: :environment do

    category = randomCategory
    browse_node_id = randomCategory.browse_node_id

    new_products_response = Nokogiri::XML(newProducts(browse_node_id, category))

    request_asins = new_products_response.xpath('//xmlns:ASIN')
    
  	#external_ids = amazonRandomProductsGenerator()
  	#response = amazonSignature()

  	#external_ids.each do |thing|
  		#if thing.exist?
  			#thing.update_product_attributes
  		#else
  			#response.parse_product_attributes
  			#thing.create_new_product_with_product_attributes 
  		#end
  	#end
  end

end
