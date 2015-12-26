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
		logger.info "Did it work?"
		render json: friends
	end

	def productqueue
		productqueue_id = User.find(params[:id]).productqueue
		render json: productqueue_id
	end

private
	def user_params
		params.require(:user).permit(:firstName)
	end
end
