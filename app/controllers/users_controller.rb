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
			render json: user, status: 201, location: user
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
		logger.info @user
		@user.update!(user_params)

		render nothing: true
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
			:age_range)
	end
end