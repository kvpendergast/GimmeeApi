class FriendshipsController < ApplicationController
  def index
	friendships = Friendship.all
	render json: @friendships
  end

  def show
  	friendship = Friendship.find(params[:id])
  end

  def create
    friendship = Friendship.create(friendship_params)
    if friendship.save
      json_hash["friendship_id"] = friendship.id
      render json: json_hash, status: 201
    end
  end

  private
	def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id)    
	end
end
