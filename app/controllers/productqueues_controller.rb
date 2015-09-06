class ProductqueuesController < ApplicationController

	def index
		@productqueues = Productqueue.all
		render json: @productqueues
	end

	def show
	end

	def new
		Productqueue.new
	end

	def create
		@productqueue = Productqueue.new(create_productqueue_params)

		newProductIds = Array.new
		request_asins = Array.new

		until newProductIds.length >= 50
		
			$count = 0
			request_asins.clear
			@randomProduct = nil
			Product.uncached do
				until $count >= 10 do
					@randomProduct = Product.order("RANDOM()").first
					request_asins.push(@randomProduct.externalId)
					$count += 1
				end
			end

			@apitag = "Ventry-20"
			@op = "ItemLookup"
			@RespGroup = "Images%2COffers%2CSmall"
			@serv = "AWSECommerceService"
			response = Nokogiri::XML(amazonSignature(request_asins, @apitag, @op, @RespGroup, @serv))
			response_fragment = Nokogiri::XML.fragment(response)
			node = Nokogiri::XML::Node.new('my_node', response)

			response_items = node.xpath('//xmlns:Item')

			titles = Array.new
			response_items.each do |item|
				#Parses the product tile and saves it to the product
				current_product = Product.find_by_externalId(item.search('ASIN').text)
				current_product.productName = item.search('Title').text
				logger.info current_product.productName

				#parses the product price and saves it to the product
				offer = item.search('Offers/TotalOffers').text.to_i
				if offer >= 1
					sale_price = item.search('Offers/Offer/OfferListing/SalePrice/FormattedPrice').text
					#checks if a sale price exists. If it does, saves as the product price
					if sale_price != '' 
						current_product.price = sale_price
					else
						current_price = item.search('Offers/Offer/OfferListing/Price/FormattedPrice').text
						current_product.price = current_price
					end
				else
					current_product.price = nil
				end
				logger.info current_product.price
				#Saves the detail_page_url to the product
				detail_page_url = item.search('DetailPageURL').text
				current_product.detailPageUrl = detail_page_url
				logger.info current_product.detailPageUrl

				logger.info '\n'

				logger.info item.search('ImageSets')

				logger.info '\n'

				logger.info item

				if item.search('ImageSets').text != ''
				  image_url = item.search('ImageSets').children.last.elements.last.search('URL').text
				  current_product.imageurl = image_url
				  logger.info current_product.imageurl
				else
				  current_product.imageurl = nil
				  logger.info 'something bad happened'
				end

				if current_product.price != nil
				  if current_product.imageurl != nil
				    newProductIds.push(current_product.id)
				  end
				end

				current_product.save
			end

		end

			@productqueue.productids.push(newProductIds)

		if @productqueue.save
			render json: @productqueue, status: 201, location: @productqueue
			#render xml: response
			#logger.info response
		end
	end

	def addproductstoqueue
		@productqueue = Productqueue.find(params[:id])
		
		newProductIds = Array.new
		request_asins = Array.new

		until newProductIds.length >= 20
		
			$count = 0
			request_asins.clear
			@randomProduct = nil
			Product.uncached do
				until $count >= 10 do
					@randomProduct = Product.order("RANDOM()").first
					request_asins.push(@randomProduct.externalId)
					$count += 1
				end
			end

			@apitag = "Ventry-20"
			@op = "ItemLookup"
			@RespGroup = "Images%2COffers%2CSmall"
			@serv = "AWSECommerceService"
			response = Nokogiri::XML(amazonSignature(request_asins, @apitag, @op, @RespGroup, @serv))
			response_fragment = Nokogiri::XML.fragment(response)
			node = Nokogiri::XML::Node.new('my_node', response)

			response_items = node.xpath('//xmlns:Item')

			titles = Array.new
			response_items.each do |item|
				#Parses the product tile and saves it to the product
				current_product = Product.find_by_externalId(item.search('ASIN').text)
				current_product.productName = item.search('Title').text
				logger.info current_product.productName

				#parses the product price and saves it to the product
				offer = item.search('Offers/TotalOffers').text.to_i
				if offer >= 1
					sale_price = item.search('Offers/Offer/OfferListing/SalePrice/FormattedPrice').text
					#checks if a sale price exists. If it does, saves as the product price
					if sale_price != '' 
						current_product.price = sale_price
					else
						current_price = item.search('Offers/Offer/OfferListing/Price/FormattedPrice').text
						current_product.price = current_price
					end
				else
					current_product.price = nil
				end
				logger.info current_product.price
				#Saves the detail_page_url to the product
				detail_page_url = item.search('DetailPageURL').text
				current_product.detailPageUrl = detail_page_url
				logger.info current_product.detailPageUrl

				logger.info '\n'

				logger.info item.search('ImageSets')

				logger.info '\n'

				logger.info item

				if item.search('ImageSets').text != ''
				  image_url = item.search('ImageSets').children.last.elements.last.search('URL').text
				  current_product.imageurl = image_url
				  logger.info current_product.imageurl
				else
				  current_product.imageurl = nil
				  logger.info 'something bad happened'
				end

				if current_product.price != nil
				  if current_product.imageurl != nil
				    newProductIds.push(current_product.id)
				  end
				end

				current_product.save
			end

		end

			@productqueue.productids.push(newProductIds)

		if @productqueue.save
			render json: @productqueue, status: 201, location: @productqueue
			#render xml: response
			#logger.info response
		end

	end

private
	def create_productqueue_params
		params.require(:productqueue).permit(:user_id)
	end

end
