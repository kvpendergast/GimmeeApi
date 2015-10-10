class ApplicationController < ActionController::Base

def parseProductResponse(response)
  node = Nokogiri::XML::Node.new('my_node', response)
  product_info = Array.new
  response_items = node.xpath('//xmlns:Item')
  count = 0
  response_items.each do |item|
    product_info[count] = {'productName' => item.search('Title').text }
    #parses the product price and saves it to the product
    offer = item.search('Offers/TotalOffers').text.to_i
    if offer >= 1
      sale_price = item.search('Offers/Offer/OfferListing/SalePrice/FormattedPrice').text
      #checks if a sale price exists. If it does, saves as the product price
      if sale_price != '' 
        product_info[count]['Price'] = sale_price
      else
        current_price = item.search('Offers/Offer/OfferListing/Price/FormattedPrice').text
        product_info[count]['Price'] = current_price
      end
    else
      product_info[count]['Price'] = nil
    end
    detail_page_url = item.search('DetailPageURL').text
    product_info[count]['DetailPageURL'] = detail_page_url

    if item.search('ImageSets').text != ''
      image_url = item.search('ImageSets').children.last.elements.last.search('URL').text
      product_info[count]['Image Url'] = image_url
    else
      product_info[count]['Image Url'] = nil
    end

    count += 1
  end

  return product_info
end

def amazonSignature(itemIds)
	@ASSOCIATE_TAG = ENV["AMAZON_ASSOCIATE_TAG"]
	@ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
	current_date = (Date.today + 1).to_s
	@RESPONSE_GROUP = 'Images%2COffers%2CSmall'
	@OPERATION = 'ItemLookup'
  @SERVICE = 'AWSECommerceService'
	timestamp = current_date << "T19%3A37%3A00Z"
	
  #Amazon Signature Generation
  @SECURITY_KEY = ENV["AMAZON_SECURITY_KEY"]
	data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&ItemId=#{itemIds[0]}%2C#{itemIds[1]}%2C#{itemIds[2]}%2C#{itemIds[3]}%2C#{itemIds[4]}%2C#{itemIds[5]}%2C#{itemIds[6]}%2C#{itemIds[7]}%2C#{itemIds[8]}%2C#{itemIds[9]}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&Service=#{@SERVICE}&Timestamp=#{timestamp}"
	hash = OpenSSL::HMAC.digest('sha256',@SECURITY_KEY,data)
	signature = Base64.encode64(hash)
	signature.gsub!('=','%3D')
	signature.gsub!('+','%2B')
	signature.gsub!(',','%2C')

  #Amazon Api Call
	response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&ItemId=#{itemIds[0]}%2C#{itemIds[1]}%2C#{itemIds[2]}%2C#{itemIds[3]}%2C#{itemIds[4]}%2C#{itemIds[5]}%2C#{itemIds[6]}%2C#{itemIds[7]}%2C#{itemIds[8]}%2C#{itemIds[9]}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&Service=#{@SERVICE}&Timestamp=#{timestamp}&Signature=#{signature}"
	
	return response
end

def randomKeywords(category)

  return keywords
end

def randomCategory

  return category
end

def amazonAsins(search_keywords, search_category)
  #Variables for signature and amazon api call
  @ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
  @ASSOCIATE_TAG = ENV["AMAZON_ASSOCIATE_TAG"]
  @AVAILABILITY = 'Available'
  keywords = search_keywords
  @OPERATION = "ItemSearch"
  @RESPONSE_GROUP = "ItemIds"
  search_index = search_category
  @SERVICE = "AWSECommerceService"
  current_date = (Date.today + 1).to_s
  timestamp = current_date << "T19%3A37%3A00Z"

  #Amazon Signature generation
  @SECURITY_KEY = ENV["AMAZON_SECURITY_KEY"]
  data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&Availability=#{@AVAILABILITY}&Keywords=#{keywords}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&SearchIndex=#{search_index}&Service=#{@SERVICE}&Timestamp=#{timestamp}"
  hash = OpenSSL::HMAC.digest('sha256',@SECURITY_KEY,data)
  signature = Base64.encode64(hash)
  signature.gsub!('=','%3D')
  signature.gsub!('+','%2B')
  signature.gsub!(',','%2C')
  signature.gsub!(':','%3A')

  #Amazon api call
  response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&Availability=#{@AVAILABILITY}&Keywords=#{keywords}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&SearchIndex=#{search_index}&Service=#{@SERVICE}&Timestamp=#{timestamp}&Signature=#{signature}"

  return response
end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
