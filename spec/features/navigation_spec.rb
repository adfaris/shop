require 'rails_helper'

RSpec.describe 'Navigation', type: :feature do
    let!(:product) { FactoryBot.create(:product) }

    context 'from the products list page' do

        before do
            # setup pre-condtions
            visit(products_path)
        end

        it 'navigates to the show page' do
            # run the subject code
            click_on(product.name)
            # evaluate expectations
            expect(page.current_path).to eq(product_path(product))
        end

        it 'navigates to the cart page' do
            click_on('View cart')
            expect(page.current_path).to eq(cart_path)
        end
    end

    context 'from the show page' do
        before do
            visit(product_path(product))
        end

        it 'navigates to the cart page' do
            click_on('View cart')
            expect(page.current_path).to eq(cart_path)
        end

        it 'navigates to the products list page' do
            click_on('Home')
            expect(page.current_path).to eq(products_path)
        end
    end

    context 'from the cart page' do
        before do
            visit(cart_path)
        end

        it 'navigates to products list page' do
            click_on('Home')
            expect(page.current_path).to eq(products_path)
        end

        context 'the cart is not empty' do
            before do
                visit(product_path(product))
                click_on('Add to cart')
            end

            it 'navigates to the show page' do
                click_on(product.name)
                expect(page.current_path).to eq(product_path(product))
            end
        end
    end
end
