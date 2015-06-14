class ActivitiesController < ApplicationController
	def index
		@activities = Activity.all
		render json: @activities
	end

	def show
		@user = User.find(params[:id])
		render :json => @user.to_json(:include => [:activities])
	end
end
