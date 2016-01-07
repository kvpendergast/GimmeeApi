class ActivitiesController < ApplicationController
  def index
	activities = Activity.all
	render json: activities
  end

  def show
	user = User.find(params[:id])
	render :json => user.to_json(:include => [:activities])
  end

  def create
	  activity = Activity.create(activity_params)
	  json_hash = Hash.new
	  if activity.save
		  json_hash["activity_id"] = activity.id
		  render json: json_hash, status: 201
	  end
  end

  def share
  	activity = Activity.find(params[:activity_id])
  	json_hash = Hash.new
    logger.info "Works"
  	shared_activity = SharedActivity.create(activity_id: params[:activity_id], 
  		product_id: params[:product_id], 
  		user_id: params[:user_id])
    logger.info params[:friend_ids].to_json
    logger.info "Did anything show?"
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
	  params.require(:activity).permit(:user_id, :product_id)
	end
end
