require 'rails_helper'

RSpec.describe 'Carts', type: :feature do
    let!(:product) { FactoryBot.create(:product) }

    context 'cart is empty' do
        context 'add item to cart' do
            before do
                visit products_path
                click_on(product.name)
                click_button('Add to cart')
            end 

            it 'displays the shopping cart' do
                expect(page.current_path).to eq(cart_path)                
            end

            it 'displays the item name' do
                expect(page.first("ul.cart li.product-#{product.id}")).to have_content(product.name)
            end 
            
            it 'displays the item quantity' do 
                expect(page.first("ul.cart li.product-#{product.id} .quantity")).to have_content('1')            
            end 
        end
    end
end