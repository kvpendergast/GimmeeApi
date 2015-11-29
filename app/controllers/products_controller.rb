class ProductsController < ApplicationController

	def index
		@products = Product.all
		render json: @products
	end

	def new
		Product.new
	end

	def create
		product = Product.create(product_params)
		if product.save
		  render json: product, status: 201, location: product
		end
	end

	def show
		@product = Product.find(params[:id])
		render json: @product
	end

	private
	  def product_params
	  	params.require(:product).permit(:externalId)
	  end
end
