class ChannelsController < ApplicationController
	def index
	end

	def create
		channel = Channel.create(channel_params)
		if channel.save
			render json: channel, status: 201
		end
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

	  channel.productids = [] if channel.productids == nil
	  
	  #check if any products with desired tag have activities with channel_viewed_count = channe.viewed_count
	  products = Product.where(tag: channel.parent_channel.tag)
	  products.each do |product|
	  	if product.activities.last.channel_viewed_count < channel.viewed_count
	  		new_product_ids.push(product.id)
	  	end
	  end

	  if new_product_ids != []
	  	until new_product_ids.length >= 20
				
	    	#This block of code randomly selects 10 product ASINs to be sent in the Amazon request
	    	new_products = randomProduct(@channel.parent_channel.tag)

	    	new_products.each do |item|
	      		if item.imageurl != nil
            		new_product_ids.push(item.id)
	  	    		Channel.productids.push(item.id)
	      		end
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
		def channel_params
			params.permit(:user_id, :parent_channel_id)
		end
end
