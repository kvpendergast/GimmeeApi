class SharedActivitiesController < ApplicationController
	def index
	end

	def show
	end

	def create
      
	end

	def activities
		activities = SharedActivity.find(params[:id]).activities.all
	end
end
