namespace :amazon do
  desc "Simple cron job placeholder. Eventually will put product upsert algorithm here?"
  task upsert_products: :environment do
    category = randomCategory
    keywords = randomKeywords(category)

    external_ids_response = Nokogiri::XML(amazonAsins(keywords,category))

    #parse external_ids_response to extract ASINS
    parsed_response_asins = external_ids_response.xpath('//xmlns:ASIN')

    #Submit ASINS to Amazon for product information
    amazon_product_response = amazonSignature(parsed_response_asins)

    #Parse amazon_product_response for product information

    #Save product information to database

  	puts "Hello!"
  end

end
