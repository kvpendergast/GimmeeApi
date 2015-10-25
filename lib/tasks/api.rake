namespace :amazon do
  desc "Simple cron job placeholder. Eventually will put product upsert algorithm here?"
  task update_amazon_products: :environment do
    App = ApplicationController.new
    #Store all amazon products into array
    amazon_products = Product.all
    products_to_update = Array.new
    updated_products = Array.new

    amazon_products.each do |product| 
      
      products_to_update.push(product.externalId) if product.updated_at <= Time.now - 86400
      puts products_to_update.length
      if products_to_update.length == 10
        puts "Yay"
        response = Nokogiri::XML(App.amazonSignature(products_to_update))
        node = Nokogiri::XML::Node.new('my_node', response)
        product_info = App.parseProductResponse(node)

        product_info.each do |item|
          if item['Price'] != nil && item['Image Url'] != nil
            @current_product = Product.find_by_externalId(item['ASIN'])
            @current_product.productName = item['productName']
            @current_product.price = item['Price']
            @current_product.detailPageUrl = item['DetailPageURL']
            @current_product.imageurl = item['Image Url']
            @current_product.save
            updated_products.push(@current_product.id)
          end
        end

        products_to_update.clear
      end
    end

    notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
    updated_products_slack = "These products have been updated:"
    updated_products.each do |product_id|
      thing = Product.find_by_id(product_id)  
      updated_products_slack << "\nProduct: #{thing.productName} Id: #{thing.id}"
    end
    notifier.ping updated_products_slack
  end
end
