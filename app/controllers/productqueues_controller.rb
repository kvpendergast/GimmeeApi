class ProductqueuesController < ApplicationController

	def index
	end

	def show
	end

	def new
		Productqueue.new
	end

	def create
		@productqueue = Productqueue.new(productqueue_params)
		if @productqueue.save
			#render json: @productqueue, status: 201, location: @productqueue
		end

		$count = 0
		asins = Array.new
		newProductIds = Array.new
		@randomProduct = nil
		Product.uncached do
			until $count > 10 do

				@randomProduct = Product.order("RANDOM()").first
				asins.push(@randomProduct.externalId)
				@productqueue.productids.push(@randomProduct.id)
				newProductIds.push(@randomProduct.id)
				$count += 1

			end
		end

		#render json: asins

		@apitag = "ventry-20"
		@op = "ItemLookup"
		@RespGroup = "Images%2COffers%2CSmall"
		@serv = "AWSECommerceService"
		response = amazonSignature(asins, @apitag, @op, @RespGroup, @serv)
		product_titles = Nokogiri.XML(response).xpath("//xmlns:Title")
		product_prices = Nokogiri.XML(response).xpath("//xmlns:FormattedPrice")
		product_large_images = Nokogiri.XML(response).xpath("//xmlns:LargeImage")
		#render xml: response

		$count = 0

		until $count > 10
			@randomProduct = Product.find(newProductIds[$count])
			@randomProduct.productName = product_titles[$count].to_s.sub("<Title>","").sub("</Title>","")
			@randomProduct.price = product_prices[$count].to_s.sub("<FormattedPrice>","").sub("</FormattedPrice>","").to_f
			#Product.find(newProductIds[$count]).productName = product_titles[$count]
			@randomProduct.save
			$count += 1
		end
		#@product_price = Nokogiri.XML(@test_product).xpath("//xmlns:FormattedPrice").first.text
		#randomProduct.productName = @product_title
		#@randomProduct.price = @product_price
		@productqueue.save
		render json: @productqueue
		#render json: @productqueue
		#@randomProduct.save

	end

	def addproductstoqueue
		
		@productqueue = Productqueue.find(params[:id])
		@randomProduct = Product.order("RANDOM()").first
		@asin = @randomProduct.externalId
		@apitag = "ventry-20"
		@op = "ItemLookup"
		@RespGroup = "Images%2COffers%2CSmall"
		@serv = "AWSECommerceService"
		@test_product = amazonSignature(@asin, @apitag, @op, @RespGroup, @serv)
		@product_title = Nokogiri.XML(@test_product).xpath("//xmlns:Title").first
		#@product_price = Nokogiri.XML(@test_product).xpath("//xmlns:FormattedPrice").first.text
		@randomProduct.productName = @product_title
		#@randomProduct.price = @product_price
		@productqueue.productids.push(@randomProduct.id)
		@productqueue.save
		@randomProduct.save

	end

private
	def productqueue_params
		params.require(:productqueue).permit(:user_id)
	end

end
