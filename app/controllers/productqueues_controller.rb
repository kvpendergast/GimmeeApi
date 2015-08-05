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
		@productqueue = Productqueue.new(productqueue_params)
		if @productqueue.save
			#render json: @productqueue, status: 201, location: @productqueue
		end

		$count = 0
		requestAsins = Array.new
		@randomProduct = nil
		Product.uncached do
			until $count >= 10 do
				@randomProduct = Product.order("RANDOM()").first
				requestAsins.push(@randomProduct.externalId)
				$count += 1
			end
		end

		@apitag = "ventry-20"
		@op = "ItemLookup"
		@RespGroup = "Images%2COffers%2CSmall"
		@serv = "AWSECommerceService"
		response = amazonSignature(requestAsins, @apitag, @op, @RespGroup, @serv)
		responseProductTitles = Nokogiri.XML(response).xpath("//xmlns:Title")
		responseTotalOffers = Nokogiri.XML(response).xpath("//xmlns:TotalOffers")
		responsePrices = Nokogiri.XML(response).xpath("//xmlns:Price/xmlns:FormattedPrice")
		responseAsins = Nokogiri.XML(response).xpath("//xmlns:ASIN")
		responsedetailpageURLs = Nokogiri.XML(response).xpath("//xmlns:DetailPageURL")
		
		$count = 0
		$priceCount = 0

		cleanedresponseProductTitles = Array.new
		cleanedresponseAsins = Array.new
		cleanedresponseTotalOffers = Array.new
		cleanedresponsedetailpageURLs = Array.new
		cleanedresponsePrices = Array.new
		currentProduct = nil
		#This loop removes the tags in the responseProductTitles, responseAins, and responseTotalOffers arrays
		until $count >= responseProductTitles.length
			cleanedresponseAsins[$count] = responseAsins[$count].to_s.sub("<ASIN>","").sub("</ASIN>","")
			currentProduct = Product.find_by_externalId(cleanedresponseAsins[$count])

			cleanedresponseProductTitles[$count] = responseProductTitles[$count].to_s.sub("<Title>","").sub("</Title>","")
			currentProduct.productName = cleanedresponseProductTitles[$count]

			cleanedresponsedetailpageURLs[$count] = responsedetailpageURLs[$count].to_s.sub("<DetailPageURL","").sub("</DetailPageURL>","")
			currentProduct.detailPageUrl = cleanedresponsedetailpageURLs[$count]

			cleanedresponseTotalOffers[$count] = responseTotalOffers[$count].to_s.sub("<TotalOffers>","").sub("</TotalOffers>","").to_i
			logger.info cleanedresponseTotalOffers[$count]
			if cleanedresponseTotalOffers[$count] > 0
				logger.info "Entered loop"
				cleanedresponsePrices[$priceCount] = responsePrices[$priceCount].to_s.sub("<FormattedPrice>","").sub("</FormattedPrice>","")
				currentProduct.price = cleanedresponsePrices[$priceCount]
				logger.info cleanedresponsePrices[$priceCount]
				@productqueue.productids.push(currentProduct.id)
				$priceCount += 1
			else
				currentProduct.price = "Not Available"
				logger.info "Not Available"
			end
			$count += 1
			currentProduct.save
			
		end

		@productqueue.save

		logger.info responsePrices
		logger.info cleanedresponsePrices
		logger.info @productqueue.productids

		render xml: response
	end

	def addproductstoqueue
		
	end

private
	def productqueue_params
		params.require(:productqueue).permit(:user_id)
	end

end