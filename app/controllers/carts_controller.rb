class CartsController < ApplicationController
    before_action :set_cart, only: [:view, :add, :remove, :update]

    def view
        render 'carts/view'
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

     def checkout
        session[:cart] = nil
        @cart = Cart.new({})
        render :view
    end

    private

    def set_cart
        if(session[:coupon_id])
            coupon = Coupon.find(session[:coupon_id])
            @cart = Cart.new(session[:cart], discount: coupon.percent_off, tax: 0.04)
        else
            @cart = Cart.new(session[:cart], tax: 0.04)
        end
    end

    def save_and_redirect_to_cart
        session[:cart] = @cart.to_h
        render :view
    end
end
