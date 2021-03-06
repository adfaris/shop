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
                    expect(page.first("div.cart div.order-subtotal")).to have_content("$125.00")
                end

                it 'does not display a discount amount' do
                    expect(page).not_to have_selector("div.cart span.order-discount")
                end

                it 'displays the correct tax amount' do
                    expect(page.first("div.cart div.order-tax")).to have_content('$5.00')
                end

                it 'displays the correct order total' do
                    expect(page.first("div.cart div.order-total")).to have_content("$130.00")
                end
            end

            context 'the cart has a coupon applied' do
                let!(:coupon) { FactoryBot.create(:coupon, code: 'Save20', percent_off: 0.2) }

                before do
                    fill_in('coupon_code', with: 'Save20')
                    click_button('Apply coupon')
                end

                it 'displays the correct subtotal' do
                    expect(page.first("div.cart div.order-subtotal")).to have_content('$125.00')
                end

                it 'displays the discount amount' do
                    expect(page.first("div.cart div.order-discount")).to have_content('-$25.00')
                end

                it 'displays the correct tax amount' do
                    expect(page.first("div.cart div.order-tax")).to have_content('$4.00')
                end

                it 'displays the correct order total' do
                    expect(page.first("div.cart div.order-total")).to have_content('$104.00')
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

        describe 'Continue shopping' do
            before do
                visit cart_path
                click_on('Continue shopping')
            end
            it 'displays the home page' do
                expect(page.current_path).to eq(products_path)
            end
        end

        describe 'Checkout product' do
            before() do
                visit cart_path
                click_on('Empty cart')
            end

            it 'displays zero subtotal' do
                expect(page.first("div.cart div.order-subtotal")).to have_content('$0.00')
            end
            it 'displays a zero tax amount' do
                expect(page.first("div.cart div.order-tax")).to have_content('$0.00')
            end
            it 'displays a zero order total' do
                binding.pry
                expect(page.first("div.cart div.order-total")).to have_content('$0.00')
            end
        end
    end
end
