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
        
        describe 'cart displays the totals' do
            before do
                3.times do
                    visit product_path(product1)
                    click_button('Add to cart') 
                end

                2.times do
                    visit product_path(product2)
                    click_button('Add to cart') 
                end

                visit(cart_path)
            end

            it 'the product 1 line item total is correct' do
                expect(page.first("ul.items li.product-#{product1.id} span.total")).to have_content('$105.00')
            end

            it 'the product 2 line item total is correct' do
                expect(page.first("ul.items li.product-#{product2.id} span.total")).to have_content('$20.00')            
            end

            it 'the order total is correct' do
                expect(page.first("div.cart span.order-total")).to have_content('$125.00')            
            end
        end      
    end
end