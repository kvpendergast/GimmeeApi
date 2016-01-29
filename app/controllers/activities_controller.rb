class ActivitiesController < ApplicationController
  def index
	activities = Activity.all
	render json: activities
  end

  def show
	activity = Acitivity.find(params[:id])
  render json: activity
  end

  def create
	  activity = Activity.create(activity_params)
    activity.channel_view_count = activity.channel.view_count
	  json_hash = Hash.new
	  if activity.save
		  json_hash["activity_id"] = activity.id  
	  end

    render json: json_hash, status: 201
  end

  def share
  	activity = Activity.find(params[:activity_id])
  	json_hash = Hash.new
  	shared_activity = SharedActivity.create(activity_id: params[:activity_id], 
  		product_id: params[:product_id], 
  		user_id: params[:user_id])
  	json_hash["shared_activity"] = shared_activity
    json_hash["reverse_activities"] = Array.new
  	friend_ids = params[:friend_ids]
  	
  	friend_ids.each do |id|
      reverse_activity = Activity.create(user_id: id, 
        product_id: params[:product_id], 
        shared_with_friend_activity_id: shared_activity.id)
      if reverse_activity.save
        json_hash["reverse_activities"].concat(reverse_activity.id)
      end
  	end

  	render json: json_hash, status: 201
  end
  private
	def activity_params
	  params.permit(:user_id, :product_id, :channel_id, :like, :gimmee, :view_time)
	end
end
