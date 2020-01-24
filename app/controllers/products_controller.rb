class ProductsController < ApplicationController
    def index
        @products = Product.all
        # session[:cart] ||= {}
        # session[:cart][1] = 3
        # session[:username] = "A.D. Faris"
    end

    def show
        @product = Product.find(params[:id])
    end

end
