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

		request_asins = Array.new
		cleaned_response_product_titles = Array.new
		cleaned_response_asins = Array.new
		cleaned_response_total_offers = Array.new
		cleaned_response_detail_page_urls = Array.new
		cleaned_response_prices = Array.new
		cleaned_response_large_image_urls = Array.new
		
		until @productqueue.productids.length >= 50
			$count = 0
			request_asins.clear
			random_product = nil
			Product.uncached do
				until $count >= 10 do
					random_product = Product.order("RANDOM()").first
					request_asins.push(random_product.externalId)
					$count += 1
				end
			end

			@op = "ItemLookup"
			@resp_group = "Images%2COffers%2CSmall"
			@serv = "AWSECommerceService"
			response = amazonSignature(request_asins, @apitag, @op, @resp_group, @serv)
			response_product_titles = Nokogiri.XML(response).xpath("//xmlns:Title")
			response_total_offers = Nokogiri.XML(response).xpath("//xmlns:TotalOffers")
			response_prices = Nokogiri.XML(response).xpath("//xmlns:Price/xmlns:FormattedPrice")
			response_asins = Nokogiri.XML(response).xpath("//xmlns:ASIN")
			response_detail_page_urls = Nokogiri.XML(response).xpath("//xmlns:DetailPageURL")
			response_large_image_urls = Nokogiri.XML(response).xpath("//xmlns:Item/xmlns:ImageSets/xmlns:ImageSet[last()]/xmlns:LargeImage/xmlns:URL")
			response_large_image_urls_v2 = Nokogiri.XML(response).xpath("//xmlns:Item/xmlns:ImageSets/xmlns:ImageSet[last()]/xmlns:*[last()]")	
			#responseLargeImageUrls = Nokogiri.XML(response).xpath("//xmlns:Item/xmlns:ImageSets/xmlns:ImageSet[last()]/xmlns:*[last()]/xmlns:URL")

			$count = 0
			$price_count = 0

			cleaned_response_product_titles.clear
			cleaned_response_asins.clear
			cleaned_response_total_offers.clear
			cleaned_response_detail_page_urls.clear
			cleaned_response_prices.clear
			cleaned_response_large_image_urls.clear
			current_product = nil
			#This loop removes the tags in the responseProductTitles, responseAins, and responseTotalOffers arrays
			until $count >= response_product_titles.length
				cleaned_response_asins[$count] = response_asins[$count].to_s.sub("<ASIN>","").sub("</ASIN>","")
				current_product = Product.find_by_externalId(cleaned_response_asins[$count])

				cleaned_response_product_titles[$count] = response_product_titles[$count].to_s.sub("<Title>","").sub("</Title>","")
				current_product.productName = cleaned_response_product_titles[$count]

				cleaned_response_detail_page_urls[$count] = response_detail_page_urls[$count].to_s.sub("<DetailPageURL>","").sub("</DetailPageURL>","")
				current_product.detailPageUrl = cleaned_response_detail_page_urls[$count]

				cleaned_response_large_image_urls[$count] = response_large_image_urls[$count].to_s.sub("<URL>","").sub("</URL>","")
				current_product.imageurl = cleaned_response_large_image_urls[$count]

				cleaned_response_total_offers[$count] = response_total_offers[$count].to_s.sub("<TotalOffers>","").sub("</TotalOffers>","").to_i
				#logger.info cleanedresponseTotalOffers[$count]
				if cleaned_response_total_offers[$count] > 0
					cleaned_response_prices[$price_count] = response_prices[$price_count].to_s.sub("<FormattedPrice>","").sub("</FormattedPrice>","")
					current_product.price = cleaned_response_prices[$price_count]
					@productqueue.productids.push(current_product.id)
					$price_count += 1
				else
					current_product.price = "Not Available"
				end
					$count += 1
					current_product.save
			
			end

		end

		if @productqueue.save
			respond_to do |format|
				format.html
				format.xml { render :xml => response}
				format.json { render :json => @productqueue, status: 201, location: @productqueue}
			end
		end
	end

	def addproductstoqueue
		@productqueue = Productqueue.find(params[:id])
		random_product = nil
		request_asins = Array.new

		cleaned_response_product_titles = Array.new
		cleaned_response_asins = Array.new
		cleaned_response_total_offers = Array.new
		cleaned_response_detail_page_urls = Array.new
		cleaned_response_prices = Array.new
		cleaned_response_large_image_urls = Array.new
		new_product_ids = Array.new
		#until newProductIds.length >= 20
			$count = 0
			request_asins.clear
			Product.uncached do 
				until $count >= 10 do
					random_product = Product.order("RANDOM()").first
					request_asins.push(random_product.externalId)
					$count += 1
				end
			end

			#@apitag = "ventry-20"
			@op = "ItemLookup"
			@resp_group = "Images%2COffers%2CSmall"
			@serv = "AWSECommerceService"
			response = amazonSignature(request_asins, @apitag, @op, @resp_group, @serv)
			response_product_titles = Nokogiri.XML(response).xpath("//xmlns:Title")
			response_total_offers = Nokogiri.XML(response).xpath("//xmlns:TotalOffers")
			response_prices = Nokogiri.XML(response).xpath("//xmlns:Price/xmlns:FormattedPrice")
			response_asins = Nokogiri.XML(response).xpath("//xmlns:ASIN")
			response_detail_page_urls = Nokogiri.XML(response).xpath("//xmlns:DetailPageURL")
			response_large_image_urls = Nokogiri.XML(response).xpath("//xmlns:Item/xmlns:ImageSets/xmlns:ImageSet[last()]/xmlns:LargeImage/xmlns:URL")
			response_large_image_urls_v2 = Nokogiri.XML(response).xpath("//xmlns:Item/xmlns:ImageSets/xmlns:ImageSet[last()]/xmlns:*[last()]")

			$count = 0
			$price_count = 0

			cleaned_response_product_titles.clear
			cleaned_response_asins.clear
			cleaned_response_total_offers.clear
			cleaned_response_detail_page_urls.clear
			cleaned_response_prices.clear
			cleaned_response_large_image_urls.clear
			current_product = nil
			until $count >= response_product_titles.length
				cleaned_response_asins[$count] = response_asins[$count].to_s.sub("<ASIN>","").sub("</ASIN>","")
				current_product = Product.find_by_externalId(cleaned_response_asins[$count])

				cleaned_response_product_titles[$count] = response_product_titles[$count].to_s.sub("<Title>","").sub("</Title>","")
				current_product.productName = cleaned_response_product_titles[$count]

				cleaned_response_detail_page_urls[$count] = response_detail_page_urls[$count].to_s.sub("<DetailPageURL>","").sub("</DetailPageURL>","")
				current_product.detailPageUrl = cleaned_response_detail_page_urls[$count]

				cleaned_response_large_image_urls[$count] = response_large_image_urls[$count].to_s.sub("<URL>","").sub("</URL>","")
				current_product.imageurl = cleaned_response_large_image_urls[$count]

				cleaned_response_total_offers[$count] = response_total_offers[$count].to_s.sub("<TotalOffers>","").sub("</TotalOffers>","").to_i

				if cleaned_response_total_offers[$count] > 0
					cleaned_response_prices[$price_count] = response_prices[$price_count].to_s.sub("<FormattedPrice>","").sub("</FormattedPrice>","")
					current_product.price = cleaned_response_prices[$price_count]
					new_product_ids.push(current_product.id)
					@productqueue.productids.push(current_product.id)
					$price_count += 1
				else
					current_product.price = "Not Available"
				end
				$count += 1
				current_product.save
			
			end

		#end

		updated_queue_hash = Hash.new
		updated_queue_hash["id"] = @productqueue.id
		updated_queue_hash["user_id"] = @productqueue.user_id
		updated_queue_hash["created_at"] = Time.now
		updated_queue_hash["updated_at"] = Time.now
		updated_queue_hash["productids"] = new_product_ids

		if @productqueue.save

			respond_to do |format|
				format.html
				format.xml { render :xml => response }
				format.json { render :json => updated_queue_hash, status: 200, location: @productqueue}
			end
			
		end

	end

private
	def create_productqueue_params
		params.require(:productqueue).permit(:user_id)
	end

end
