require 'rails_helper'

RSpec.describe 'Carts', type: :feature do
    context 'cart is empty' do
        let!(:product) { FactoryBot.create(:product) }

        describe 'add item to cart' do
            before do
                visit products_path
                click_on(product.name)
                click_button('Add to cart')
            end 

            it 'displays the shopping cart' do
                expect(page.current_path).to eq(cart_path)                
            end

            it 'displays the item name' do
                expect(page.first("ul.items li.product-#{product.id}")).to have_content(product.name)
            end 
            
            it 'displays the item quantity' do 
                expect(page.first("ul.items li.product-#{product.id} .quantity")).to have_content('1')            
            end 
        end
    end

    context 'the cart contains multiple items of varying quantieies' do
        let!(:product1) { FactoryBot.create(:product, price_in_cents: 3_500) }
        let!(:product2) { FactoryBot.create(:product, price_in_cents: 1_000) }
        
        before do
            3.times do
                visit product_path(product1)
                click_button('Add to cart') 
            end

            2.times do
                visit product_path(product2)
                click_button('Add to cart') 
            end
        end

        describe 'cart displays the totals' do
            before do
                visit(cart_path)
            end

            it 'displays the correct total for the product 1 line item' do
                expect(page.first("ul.items li.product-#{product1.id} span.total")).to have_content('$105.00')
            end

            it 'displays the correct total for the product 2 line item' do
                expect(page.first("ul.items li.product-#{product2.id} span.total")).to have_content('$20.00')            
            end

            context 'the cart does not have a coupon applied' do
                it 'does not display an order subtotal' do
                    
                end

                it 'does not display a discount amount' do
                end

                it 'displays the correct order total' do
                    expect(page.first("div.cart span.order-total")).to have_content('$125.00')            
                end
            end

            context 'the cart has a coupon applied' do
                before do
                    fill_in('coupon_code', with: 'Save20')
                    click_button('Apply coupon')
                end

                it 'displays the correct subtotal' do
                    expect(page.first("div.cart span.order-subtotal")).to have_content('$125.00')
                end
                
                it 'displays the discount amount' do
                    expect(page.first("div.cart span.order-discount")).to have_content('-$25.00')
                end

                it 'displays the correct order total' do         
                    expect(page.first("div.cart span.order-total")).to have_content('$100.00')            
                end
            end 
        end
        
        describe 'remove a line item from the cart' do
            before do
                visit(cart_path)
                page.first("ul.items li.product-#{product1.id}").click_button("X")
            end 

            it 'removes the item from the cart' do
                expect(page).not_to have_selector("ul.items li.product-#{product1.id}")
            end

            it 'does not remove the other item from the cart' do
                expect(page.first("ul.items li.product-#{product2.id}")).not_to eq(nil)
            end
        end
    end
end