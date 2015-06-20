class UsersController < ApplicationController
	def index
		@users = User.all
		render json: @users
	end

	def show
		@user = User.find(params[:id])
		render json: @user
	end

	def friends
		@friends = User.find(params[:id]).friendships.all
	end

end
