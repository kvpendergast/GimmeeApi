class ChannelsController < ApplicationController
	def index
	end

	def create
	end

	def new
	end

	def show

	  #find channel and store into channel variable
	  channel = Channel.find(params[:id])

	  #Pull products that have the same tag as that channel

	  #Filter out products that have already been displayed
	  response_hash = Hash.new
	  response_hash["id"] = channel.id
	  response_hash["user_id"] = channel.user_id

	  render json: response_hash, status: 200
	end

	def add_products
	  channel = Channel.find(params[:id])
	  new_product_ids = Array.new
	  request_asins = Array.new

	  @productqueue.productids = [] if @productqueue.productids == nil

	  until new_product_ids.length >= 20
				
	    #This block of code randomly selects 10 product ASINs to be sent in the Amazon request
	    new_products = randomProduct(@productqueue.tag)

	    new_products.each do |item|
	      if item.imageurl != nil
            new_product_ids.push(item.id)
	  	    @productqueue.productids.push(item.id)
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
