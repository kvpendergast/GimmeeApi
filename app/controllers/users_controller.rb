class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		#@user.find_by(params[:id])
	end

end
