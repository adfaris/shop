class CartsController < ApplicationController
    before_action :set_cart, only: [:view, :add, :remove, :update]

    def view
    end 

    def add
        @cart.add_by_id(params[:product_id])
        save_and_redirect_to_cart
    end

    def remove
        @cart.remove_by_id(params[:product_id])
        save_and_redirect_to_cart
    end

    def update
        # find coupon with code
        # if it exists set the session
        # coupon_id to the id of the coupon

        if params[:coupon_code]
            session[:coupon_code] = params[:coupon_code]
        end
        save_and_redirect_to_cart
    end

    private

    def set_cart
        # if the session has a coupon_id
        # fetch the coupon from the db
        # pass the discount into the cart

        if(session[:coupon_code])
            @cart = Cart.new(session[:cart], 0.2)
        else 
            @cart = Cart.new(session[:cart])
        end 
    end

    def save_and_redirect_to_cart 
        session[:cart] = @cart.to_h 
        redirect_to(cart_path)
    end
end
