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
			response_hash["message"] = "No Profile Found"
			response_hash["id"] = @user.id
			render json: response_hash
		elsif @user.update(username: user_params[:username]) == false && user_params[:username] != nil
			response_hash["message"] = "Username already exists"
			response_hash["id"] = @user.id
			render json: response_hash
		elsif @user.update(phone: user_params[:phone]) == false && user_params[:phone] != nil
			response_hash["message"] = "An account already exists with that phone"
			response_hash["id"] = @user.id
			render json: response_hash
		elsif @user.update(facebook_id: user_params[:facebook_id]) == false && user_params[:facebook_id] != nil
			@user = User.find_by_facebook_id(user_params[:facebook_id])
			render json: @user
		elsif @user.update(email: user_params[:email]) == false && user_params[:email] != nil
			response_hash["email"] = "An account already exists with that email"
			response_hash["id"] = @user.id
			render json: response_hash
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