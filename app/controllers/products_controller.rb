class ProductsController < ApplicationController
	require 'openssl'
	require 'base64'
	require 'rest-client'
	require 'Nokogiri'

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
