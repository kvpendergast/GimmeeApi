class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		@user.find(params[:id])
		render json: @user
	end

end
