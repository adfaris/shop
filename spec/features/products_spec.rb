require 'rails_helper'

RSpec.describe 'Products', type: :feature do
    context 'list products' do
        it 'displays the product list' do
            visit products_path
            expect(page).to have_selector('ul.products')
        end

        it 'displays the correct number of products' do
            Product.create(name: 'MacBook', body:'13" slim and light weight')
            visit products_path
            expect(page.all('li.product').count).to eq(Product.count)
        end

        it 'links to product show page' do
            product = Product.create(name: 'MacBook', body:'13" slim and light weight')
            visit products_path
            click_on(product.name)
            expect(page.current_path).to eq(product_path(product))
        end 
    end

    context 'show product' do
        let(:product) { Product.create(name: 'MacBook', body:'13" slim and light weight') }
    
        before do #each is also an option to run this bit before eval
            visit product_path(product)
        end

        it 'displays a product' do 
            expect(page).to have_selector('div.product')
        end 

        it 'displays the requested product' do 
            expect(page).to have_content(product.name)
        end 

        it 'displays the product description' do
            expect(page).to have_content(product.body)
        end 
    end
end
