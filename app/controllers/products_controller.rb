class ProductsController < ApplicationController

	def index
		@products = Product.all
		render json: @products
	end

	def new
		Product.new
	end

	def create
		  product = Product.create(externalId: product_params["externalId"], tag: product_params["tag"])
		  
		  response = Nokogiri::XML(add_one_product(product.externalId))
		  node = Nokogiri::XML::Node.new('my_node', response)
		  product_info = parseProductResponse(node)
		  product_info.each do |item|
		    logger.info item.keys
		    product.productName = item['productName']
		    product.price = item['Price']
		    product.imageurl = item['Image Url']
		    product.detailPageUrl = item['DetailPageURL']
		  end
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
	  	params.require(:product).permit(:externalId, :tag)
	  end
end
