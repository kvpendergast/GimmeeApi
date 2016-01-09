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
			render json: user, except: [:created_at, :updated_at, :encrypted_password], status: 201, location: user
		end
	end

	def show
		@user = User.find(params[:id])
		render json: @user
	end

	def friends
		friends = User.find(params[:id]).friendships.all
		render json: friends
	end

	def productqueue
		productqueue_id = User.find(params[:id]).productqueue
		render json: productqueue_id
	end

	def update
		@user = User.find(params[:id])
		response_hash = Hash.new
		if @user.update(user_params)
			response_hash["message"] = "User Successfully Created"
			response_hash["id"] = @user.id
			render json: response_hash, status: 201
		else 
			#response_hash["status"] = 403
			#response_hash["message"] = "User already exists"
			#response_hash["user"] = User.find_by_facebook_id(user_params[:facebook_id]).to_json
			@user = User.find_by_facebook_id(user_params[:facebook_id]).to_json
			render json: @user
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
			:gender)
	end
end