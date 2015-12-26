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
    friendship.accepted = false
    friendship.initiated_friendship = true
    
    if friendship.save
      render json: friendship, status: 201
    end

    reverse_friendship = Friendship.create(
      user_id: friendship.friend_id, 
      friend_id: friendship.user_id, 
      accepted: false,
      initiated_friendship: false
      )
    reverse_friendship.save
  end

  def accept_friend_request
    friendship = Friendship.find(params[:id])
    friendship.accepted = true
    friendship.save

    reverse_friendship = Friendship.find_by_user_id_and_friend_id(friendship.friend_id, friendship.user_id)
    reverse_friendship.accepted = true
    reverse_friendship.save

    response_hash = Hash.new
    response_hash["friendship"] = friendship
    response_hash["reverse friendship"] = reverse_friendship
    render json: response_hash
  end

  def reject_friend_request
    friendship = Friendship.find(params[:id])
    reverse_friendship = Friendship.find_by_user_id_and_friend_id(friendship.friend_id, friendship.user_id)

    if reverse_friendship != nil
      reverse_friendship.destroy
    end

    friendship.destroy
    response_hash = Hash.new
    response_hash["message"] = "Friendship rejected"

    render json: response_hash
  end

  private
	  def friendship_params
      params.require(:friendship).permit(:user_id, :friend_id)    
	  end
end
