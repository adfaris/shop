class CartsController < ApplicationController
    before_action :set_cart, only: [:view, :add, :remove, :update]

    def view
    end 

    def add
        @cart.add_by_id(params[:product_id])
        save_and_redirect_to_cart
    end

    def remove
        @cart.(params[:product_id])
        save_and_redirect_to_cart
    end

    def update
        # get the coupon 
        # if valid update cart
        save_and_redirect_to_cart
    end

    private

    def set_cart
        @cart = Cart.new(session[:cart])
    end

    def save_and_redirect_to_cart 
        session[:cart] = @cart.to_h 
        redirect_to(cart_path)
    end
end
