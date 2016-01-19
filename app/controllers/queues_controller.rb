class QueuesController < ApplicationController

	def index
		queues = Queue.all
		queues_hash = Array.new
		count = 0
		queues.each do |row|
		  queues_hash[count]= {'queue_id' => row.id.to_s }
		  queues_hash[count]['Tag'] = row.tag
		  count += 1
	    end
		render json: queues_hash
	end

	def show
		@queue = Queue.find(params[:id])
		render json: @queue
	end

	def new
		Queue.new
	end

	def create
	  @queue = Queue.new()

	  new_product_ids = Array.new

      new_ids = Array.new

	  until new_product_ids.length >= 50
		
	    $count = 0
	    new_ids.clear
	    random_product = nil

	    new_products = randomProduct

	    new_products.each do |item|
	      if item.price != nil && item.imageurl != nil
	  
	      	
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
	
	  if @queue.save
		render :json => @queue, status: 201, location: @queue
	  end
	end

	def addproductstoqueue
	  @queue = Queue.find(params[:id])
	  new_product_ids = Array.new
	  request_asins = Array.new

	  @queue.productids = [] if @queue.productids == nil

	  until new_product_ids.length >= 20
				
	    #This block of code randomly selects 10 product ASINs to be sent in the Amazon request
	    new_products = randomProduct(@queue.tag)

	    new_products.each do |item|
	      if item.imageurl != nil
            new_product_ids.push(item.id)
	  	    @queue.productids.push(item.id)
	      end
	    end
      end

	  updated_queue_hash = Hash.new
	  updated_queue_hash["id"] = @queue.id
      updated_queue_hash["user_id"] = @queue.user_id
	  updated_queue_hash["created_at"] = Time.now
	  updated_queue_hash["updated_at"] = Time.now
	  updated_queue_hash["productids"] = new_product_ids

	  if @queue.save
		render json: updated_queue_hash, status: 200, location: @queue
	  end
	end

private
	def create_queue_params
		
	end
end
