class ActivitiesController < ApplicationController
	def index
		@activities = Activity.all
		render json: @activities
	end

	def show
		@user = User.find(params[:id])
		render :json => @user.to_json(:include => [:activities])
	end

	def create
		@user = User.find(params[create_activity_params])
		product_attributes = Product.find(params[:id])
		Activity.create(product_attributes, user_id: @user.id)
	end

	private
		def create_activity_params
			params.require(:activity).permit(:user_id)
		end
end
