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
	  #Save channel to a variable
	  channel = Channel.find(params["id"])
	  #Pull products that have that channel's tag
	  channel_products = Product.where(tag: channel.parent_channel.tags)
	  logger.info channel_products.as_json
	  new_products = Array.new
	  if channel.view_count == 0
	  	channel_products.each do |product|
	  	  new_products.push(product.id)
	  	end
	  else
	  	Product.uncached do
	    	channel_products.each do |product|
	  	  	viewed = false
	  	  	logger.info product.as_json
	  	  	if !product.activities.where(channel_id: channel.id).last.nil?
	  	      if product.activities.where(channel_id: channel.id).last.channel_view_count == channel.view_count
	  	  		viewed = true
	  	      end
	  	      if viewed == false
	  	  	    new_products.push(product.id)
	  	      end
	  	    end
	  	    if new_products.length == 20
	  	    	break
	  	    end
	      end
	    end
	  end
	  new_products.shuffle!
	  if new_products.length < 20
	  	response_hash = Hash.new
	  	response_hash["productList"] = new_products
	  	response_hash["channelEnd"] = true
	  else
	  	response_hash["productList"] = new_products
	  	response_hash["channelEnd"] = false
	  end
	  render json: response_hash
	end

	def view_count
		channel = Channel.find(params[:id])
		channel.view_count += 1
		channel.save
		render json: channel, status: 200
	end

	private
		def channel_params
			params.permit(:user_id, :parent_channel_id)
		end
end
