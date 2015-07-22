class ProductsController < ApplicationController

	def index
		@products = Product.all
		render json: @products
	end

	def new
		Product.new
	end

	def create

	end

	def show
		@product = Product.find(params[:id])
		render json: @product
	end
end
