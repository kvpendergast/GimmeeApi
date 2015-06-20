class FriendshipsController < ApplicationController
	def index
		@friendships = Friendship.all
		render json: @friendships
	end

	def show
		@friendship = Friendship.find(params[:id])
	end
end
