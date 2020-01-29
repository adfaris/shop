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
        coupon = Coupon.find_by_code(params[:coupon_code])
        if(coupon) 
            session[:coupon_id] = coupon.id
        end
        save_and_redirect_to_cart
     end

    private

    def set_cart
        if(session[:coupon_id])
            coupon = Coupon.find(session[:coupon_id])
            @cart = Cart.new(session[:cart], discount: coupon.percent_off)
        else 
            @cart = Cart.new(session[:cart])
        end 
    end

    def save_and_redirect_to_cart 
        session[:cart] = @cart.to_h 
        redirect_to(cart_path)
    end
end
