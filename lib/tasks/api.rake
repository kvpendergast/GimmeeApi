namespace :amazon do
  desc "Simple cron job placeholder. Eventually will put product upsert algorithm here?"
  task update_amazon_products: :environment do
    App = ApplicationController.new
    #Store all amazon products into array
    
    amazon_products = Product.where('updated_at < ?', 1.days.ago)
    updated_products = Array.new
    temp_arr = Array.new
    temp_arr_2 = Array.new
    changed = false

    puts amazon_products.length

    amazon_products.each do |thing|
      temp_arr.push(thing.externalId)
      temp_arr_2.push(thing)
      if temp_arr.length == 10
        response = Nokogiri::XML(App.amazonSignature(temp_arr))
        node = Nokogiri::XML::Node.new('my_node', response)
        product_info = App.parseProductResponse(node)
        temp_arr.clear
        @current_product = nil
        product_info.each do |item|
          @current_product = Product.find_by_externalId(item['ASIN'])
          last_update_date = @current_product.updated_at
          @current_product.productName = item['productName']
          @current_product.price = item['Price']
          @current_product.detailPageUrl = item['DetailPageURL']
          @current_product.imageurl = item['Image Url']
          @current_product.save
          if last_update_date != @current_product.updated_at
            updated_products.push(@current_product.id)
            puts "changed"
          end
        end
        sleep(1)
      end
    end
    puts updated_products.length

      puts updated_products.length
      notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", username: 'Philtar'
      updated_products_slack = "These products have been updated:"
      updated_products.each do |product_id|
        thing = Product.find_by_id(product_id)  
        updated_products_slack << "\nProduct: #{thing.productName} Id: #{thing.id} updated_at: #{thing.updated_at}"
      end
    notifier.ping updated_products_slack
  end
end
