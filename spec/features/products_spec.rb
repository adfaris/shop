require 'rails_helper'

RSpec.describe 'Products', type: :feature do
    let!(:product) { FactoryBot.create(:product) }

    context 'list products' do
        before do
            visit products_path
        end 

        it 'displays the product list' do
            expect(page).to have_selector('ul.products')
        end

        it 'displays the correct number of products' do
            expect(page.all('li.product').count).to eq(Product.count)
        end

        it 'links to product show page' do
            click_on(product.name)
            expect(page.current_path).to eq(product_path(product))
        end 
    end

    context 'show product' do
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

        it 'displays the product price' do 
            expect(page).to have_content(product.price_in_cents)
        end 
    end

    # context 'show price' do
    #     it 'shows price on page' do 
    #         expect(page).to have_selector(ul.price)
    #     end 
    # end

end
