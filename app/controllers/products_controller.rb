class ProductsController < ApplicationController

	def index
		@products = Product.all
		render json: @products
	end

	def new
		Product.new
	end

	def create
		logger.info product_params["externalId"]
		if Product.exists?(externalId: product_params["externalId"])
		  message = Hash.new
		  message["message"] = "Product already exists"
		  render json: message   
		else
		  product = Product.create(externalId: product_params["externalId"])
		  if product.save
		    render json: product, status: 201, location: product
		  end
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
