class CartsController < ApplicationController
    def view
        @cart = Cart.new(session[:cart])
    end 

    def add
        cart = Cart.new(session[:cart])
        cart.add_by_id(params[:product_id])
        session[:cart] = cart.to_h
        redirect_to(cart_path)
    end

    def remove
        cart = Cart.new(session[:cart])
        cart.remove_by_id(params[:product_id])
        session[:cart] = cart.to_h
        redirect_to(cart_path)
    end
end
