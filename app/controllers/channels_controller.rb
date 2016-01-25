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
	  channel_products = Product.where(tag: channel.tag)
	  new_products = Array.new
	  channel_products.each do |product|
	  	viewed = false
	  	product.activities.each do |activity|
	  	  if activity.last.channel_view_count == channel.view_count
	  	  	viewed = true
	  	  end
	  	end
	  	if viewed == false
	  		new_products.push(product.id)
	  	end
	  end

	  if new_products.empty?
	  	render json: "No more products"
	  else
	  	render json: new_products
	  end



	end
	private
		def channel_params
			params.permit(:user_id, :parent_channel_id)
		end
end
