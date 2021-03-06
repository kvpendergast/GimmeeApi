class ApplicationController < ActionController::Base

def parseProductResponse(response)
  node = Nokogiri::XML::Node.new('my_node', response)
  product_info = Array.new
  response_items = node.xpath('//xmlns:Item')
  count = 0
  response_items.each do |item|
    product_info[count] = {'productName' => item.search('Title').text }
    product_info[count]['ASIN'] = item.search('ASIN').text
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
      product_info[count]['Price'] = 'N/A'
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
  #Randomly generate some category
end

def categoryHierarchy

  @ASSOCIATE_TAG = "my-tag-20"
  @ACCESS_KEY = "AKIAIHMGKYWGXDTROKMA"
  @current_date = (Date.today).to_s
  @OPERATION = "BrowseNodeLookup"
  @browse_node_id = "1000"
  @SERVICE = "AWSECommerceService"
  @timestamp = "2015-10-13T11%3A20%3A12.000Z"

  #Unsigned Request: http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemSearch&AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Operation=BrowseNodeLookup&Version=2013-08-01&BrowseNodeId=465600&AssociateTag=mytag-20&ResponseGroup=BrowseNodeInfo,TopSellers,NewReleases,MostWishedFor,MostGifted
  #Signed Request: http://webservices.amazon.com/onca/xml?AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&AssociateTag=mytag-20&BrowseNodeId=465600&Operation=BrowseNodeLookup&Operation=ItemSearch&ResponseGroup=BrowseNodeInfo%2CTopSellers%2CNewReleases%2CMostWishedFor%2CMostGifted&Service=AWSECommerceService&Timestamp=2014-08-18T17%3A38%3A12.000Z&Version=2013-08-01&Signature=t48XyuQKLcYROCm7w%2FNqo3mihqB%2FQF2B9b9SX3FIOnU%3D
  #Amazon Signature Generation
  @SECURITY_KEY = "R0pkbBP5YgtpR7Qqt+UrLy0HzxB/8PbnKIbyeDSX"
  @data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=AKIAIHMGKYWGXDTROKMA&"\
  "AssociateTag=Ventry-20&"\
  "BrowseNodeId=1000&"\
  "Operation=BrowseNodeLookup&"\
  "Service=AWSECommerceService&Timestamp=#{@timestamp}"
  @hash = OpenSSL::HMAC.digest('sha256',"R0pkbBP5YgtpR7Qqt+UrLy0HzxB/8PbnKIbyeDSX",@data)
  @signature = Base64.encode64(@hash)
  @signature.gsub!('=','%3D')
  @signature.gsub!('+','%2B')
  @signature.gsub!(',','%2C')
  @signature.gsub!(':','%3A')

  print url = "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=AKIAIHMGKYWGXDTROKMA"\
  "&AssociateTag=Ventry-20&"\
  "BrowseNodeId=1000&"\
  "Operation=BrowseNodeLookup&"\
  "&Service=AWSECommerceService&Timestamp=#{@timestamp}&Signature=#{@signature}"
  #Amazon Api Call
  response = RestClient.get url

end

def amazonAsins(search_keywords, search_category)
  #Variables for signature and amazon api call
  @ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
  @ASSOCIATE_TAG = 'my-tag-20'#ENV["AMAZON_ASSOCIATE_TAG"]
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

def randomProduct(tag)
  $count = 0
  random_product_ids = Array.new
  random_product_ids.clear
  random_product = nil
  random_products = Array.new
  Product.uncached do
    until $count >= 10 do
      random_product = Product.order("RANDOM()").first if tag == 'Random'
      random_product = Product.where(:tag => "#{tag}").order("RANDOM()").first if tag != 'Random'
      
      random_products.push(random_product)
      $count += 1 if random_product.tag = tag
    end
  end

  return random_products
end

def newProducts(browse_node_id, category)

associateTag = 'my-tag-20'#ENV["AMAZON_ASSOCIATE_TAG"]
@accesskey = ENV["AMAZON_ACCESS_KEY"]
operation = "ItemSearch"
browse_node = browse_node_id
searchindex = category
responsegroup = "ItemIds"
service = "AWSECommerceService"
currentdate = (Date.today + 1).to_s
@timestamp = currentdate << "T19%3A37%3A00Z"
@securitykey = ENV["AMAZON_SECURITY_KEY"]
@data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&Availability=Available&BrowseNode=#{browse_node}&Operation=#{operation}&ResponseGroup=#{responsegroup}&SearchIndex=#{searchindex}&Service=#{service}&Timestamp=#{@timestamp}"
@hash = OpenSSL::HMAC.digest('sha256',@securitykey,@data)
@signature = Base64.encode64(@hash)
@signature.gsub!('=','%3D')
@signature.gsub!('+','%2B')
@signature.gsub!(',','%2C')
@signature.gsub!(':','%3A')
@response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@accesskey}&AssociateTag=#{associateTag}&Availability=Available&BrowseNode=#{browse_node}&Operation=#{operation}&ResponseGroup=#{responsegroup}&SearchIndex=#{searchindex}&Service=#{service}&Timestamp=#{@timestamp}&Signature=#{@signature}"

return response
end

def add_one_product(externalId)
  @ASSOCIATE_TAG = "my-tag-20" #ENV["AMAZON_ASSOCIATE_TAG"]
  @ACCESS_KEY = ENV["AMAZON_ACCESS_KEY"]
  current_date = (Date.today + 1).to_s
  @RESPONSE_GROUP = 'Images%2COffers%2CSmall'
  @OPERATION = 'ItemLookup'
  @SERVICE = 'AWSECommerceService'
  timestamp = current_date << "T19%3A37%3A00Z"
  
  #Amazon Signature Generation
  @SECURITY_KEY = ENV["AMAZON_SECURITY_KEY"]
  data = "GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&ItemId=#{externalId}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&Service=#{@SERVICE}&Timestamp=#{timestamp}"
  hash = OpenSSL::HMAC.digest('sha256',@SECURITY_KEY,data)
  signature = Base64.encode64(hash)
  signature.gsub!('=','%3D')
  signature.gsub!('+','%2B')
  signature.gsub!(',','%2C')

  #Amazon Api Call
  response = RestClient.get "http://webservices.amazon.com/onca/xml?AWSAccessKeyId=#{@ACCESS_KEY}&AssociateTag=#{@ASSOCIATE_TAG}&ItemId=#{externalId}&Operation=#{@OPERATION}&ResponseGroup=#{@RESPONSE_GROUP}&Service=#{@SERVICE}&Timestamp=#{timestamp}&Signature=#{signature}"
  return response
end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
