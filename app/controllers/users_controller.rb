class UsersController < ApplicationController
	skip_before_filter  :verify_authenticity_token

	def index
		@users = User.all
		render json: @users
	end

	def new
		User.new
	end

	def create
	  user = User.new(user_params)
	  if user.save
		render json: user.as_json.compact, except: [:created_at, :updated_at, :encrypted_password], status: 201, location: user
	  end

	  ParentChannel.all.each do |parent_channel|
	  	if parent_channel.default == true
		  Channel.create(parent_channel_id: parent_channel.id, user_id: user.id, view_count: 1)
		end
	  end
	end

	def show
		@user = User.find(params[:id])
		render json: @user.as_json.compact
	end

	def friends
		friends = User.find(params[:id]).friendships.all
		render json: friends
	end

	def parent_channels
		parent_channels = User.find(params[:id]).channels
		response_hash = Hash.new
		i = 0
		parent_channels.each do |chan|
			response_hash[i] = chan.parent_channel
			i = i + 1
		end

		render json: response_hash, status: 200
	end

	def channels
		channels = User.find(params[:id]).channels
		response_array = Array.new
		i = 0
		channels.each do |chan|
			response_array[i] = Hash.new
			response_array[i] = chan.parent_channel.as_json
			response_array[i].delete("created_at")
			response_array[i].delete("updated_at")
			response_array[i][:id] = chan.id

			intermediate_hash = Hash.new
			intermediate_hash[:parent_channel_id] = chan.parent_channel.id
			response_array[i].merge!(intermediate_hash).compact!
			i = i + 1
		end

		element_to_add = response_array.select {|element| element["tags"] == "#gimmee"}
		response_array.delete_if {|e| e["tags"] == "#gimmee"}
		response_array.unshift(element_to_add)
		render json: response_array.compact.to_json
	end

	def activities
		user = User.find(params[:id])
		activities = user.activities
		render json: activities
	end

	def update
		user = User.find(params[:id])
		response_hash = Hash.new
		logger.info user_params
		user.assign_attributes(user_params)
		user.valid?
		if user.errors.empty?
			user.save
			logger.info user.errors.messages
			response_hash["message"] = "matching_profile_not_found"
			response_hash["id"] = user.id
			render json: response_hash
		elsif user.errors.messages.include?(:facebook_id)
			user = User.find_by_facebook_id(user_params[:facebook_id])
			render json: user.as_json.compact, status: 200
		elsif user.errors.messages.include?(:username)
			response_hash["message"] = "username_exists"
			response_hash["id"] = user.id
			render json: response_hash, status: 400
		elsif user.errors.messages.include?(:phone)
			response_hash["message"] = "phone_exists"
			response_hash["id"] = user.id
			render json: response_hash, status: 400
		elsif user.errors.messages.include?(:email)
			response_hash["message"] = "email_exists"
			response_hash["id"] = user.id
			render json: response_hash, status: 400
		end
	end

private
	def user_params
		params.permit(
			:firstName, 
			:lastName, 
			:email, 
			:username, 
			:phone,
			:facebook_id, 
			:facebookAccessToken, 
			:locale,
			:timezone,
			:age_min,
			:age_max,
			:gender,
			:id,
			:user)
	end
end