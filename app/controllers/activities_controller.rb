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
		activity = Activity.create(activity_params)
		if activity.save
			json_hash["activity_id"] = activity.id
			render json: json_hash, status: 201
		end

	end

	private
		def activity_params
			params.require(:activity).permit(:user_id, :product_id, :purchased, :viewTime, :productName, :price, :imageurl, :externalid, :detailPageUrl, :supplier_id)
		end
end
