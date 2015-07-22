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
			render json: @productqueue, status: 201, location: @productqueue
		end

		$count = 0

		until $count >= 20 do 
			@randomProduct = Product.order("RANDOM()").first
			@asin = @randomProduct.externalId
			@apitag = "ventry-20"
			@op = "ItemLookup"
			@RespGroup = "Images%2COffers%2CSmall"
			@serv = "AWSECommerceService"
			@test_product = amazonSignature(@asin, @apitag, @op, @RespGroup, @serv)
			@product_title = Nokogiri.XML(@test_product).xpath("//xmlns:Title").first.text
			#@product_price = Nokogiri.XML(@test_product).xpath("//xmlns:FormattedPrice").first.text
			@randomProduct.productName = @product_title
			#@randomProduct.price = @product_price
			@productqueue.productids.push(@randomProduct.id)
			@productqueue.save
			@randomProduct.save

			$count += 1
		end

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
		@product_title = Nokogiri.XML(@test_product).xpath("//xmlns:Title").first.text
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
