class ProductqueuesController < ApplicationController

	def index
		productqueues = Productqueue.all
		productqueue_ids = []
		productqueues.each { |thing| productqueue_ids.push(thing.id) }
		render json: productqueue_ids
	end

	def show
	end

	def new
		Productqueue.new
	end

	def create
	  #Initializes a new productqueue
	  @productqueue = Productqueue.new()
	  logger.info @productqueue.id

	  #Initializes the array that will store the product ids for the queue
	  new_product_ids = Array.new

      #Initializes the array that will store the asins sent to amazon
      request_asins = Array.new

	  #This loop makes sure that the productqueue has at least 50 products in it initially
	  until new_product_ids.length >= 50
		
	  #This block of code randomly selects 10 product ASINs to be sent in the Amazon request
	    $count = 0
	    request_asins.clear
	    random_product = nil

	    request_asins = randomProduct

	    response = Nokogiri::XML(amazonSignature(request_asins))
	    node = Nokogiri::XML::Node.new('my_node', response)

	    product_info = parseProductResponse(node)

	    product_info.each do |item|
	      if item['Price'] != nil && item['Image Url'] != nil
	      	@current_product = Product.find_by_externalId(item['ASIN'])
	      	logger.info @current_product
	      	@current_product.productName = item['productName']
	      	@current_product.price = item['Price']
	      	@current_product.detailPageUrl = item['DetailPageURL']
	      	@current_product.imageurl = item['Image Url']
	      	@current_product.save
            new_product_ids.push(@current_product.id)
            #logger.info new_product.id
	  	    @productqueue.productids.push(@current_product.id)
	      end
	    end
	  end
	
	  if @productqueue.save
		render :json => @productqueue, status: 201, location: @productqueue
		#render xml: response
			#respond_to do |format|
			#	format.html
			#	format.xml { render :xml => response}
			#	format.json { render :json => @productqueue, status: 201, location: @productqueue}
			#end
	  end
	end

	def addproductstoqueue
	  @productqueue = Productqueue.find(params[:id])
	  new_product_ids = Array.new
	  request_asins = Array.new

	  @productqueue.productids = [] if @productqueue.productids == nil

	  until new_product_ids.length >= 20
				
	    #This block of code randomly selects 10 product ASINs to be sent in the Amazon request
	    logger.info @productqueue.tag
	    request_asins = randomProduct(@productqueue.tag)

	    response = Nokogiri::XML(amazonSignature(request_asins))
	    node = Nokogiri::XML::Node.new('my_node', response)

	    product_info = parseProductResponse(node)

	    product_info.each do |item|
	      if item['Price'] != nil && item['Image Url'] != nil
	      	@current_product = Product.find_by_externalId(item['ASIN'])
	      	@current_product.productName = item['productName']
	      	@current_product.price = item['Price']
	      	@current_product.detailPageUrl = item['DetailPageURL']
	      	@current_product.imageurl = item['Image Url']
	      	@current_product.save
            new_product_ids.push(@current_product.id)
            #logger.info new_product.id
	  	    @productqueue.productids.push(@current_product.id)
	      end
	    end
      end

	  updated_queue_hash = Hash.new
	  updated_queue_hash["id"] = @productqueue.id
      updated_queue_hash["user_id"] = @productqueue.user_id
	  updated_queue_hash["created_at"] = Time.now
	  updated_queue_hash["updated_at"] = Time.now
	  updated_queue_hash["productids"] = new_product_ids

	  if @productqueue.save
		#respond_to do |format|
		#  format.html
		#  format.xml { render :xml => response }
		#  format.json { render :json => updated_queue_hash, status: 200, location: @productqueue}
		#end
		render json: updated_queue_hash, status: 200, location: @productqueue
		#render xml: response
	  end
	end

private
	def create_productqueue_params
		#params.require(:productqueue).permit(:user_id)
	end
end
