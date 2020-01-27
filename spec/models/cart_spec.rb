require 'rails_helper'

RSpec.describe Cart, type: :model do
    describe '.new' do
        context 'valid arguments' do
            it 'does not raise an exception' do
                expect { Cart.new({1 => 1}) }.not_to raise_exception
            end
        end

        context 'invalid arguments' do
            it 'raises an ArgumentError' do
                expect { Cart.new("string") }.to raise_exception(ArgumentError)
            end
        end
    end

    # ClassName.total class method class#total instance method
    describe '#total' do
        context 'the cart is empty' do
            let(:cart) { Cart.new({}) } 

            it 'returns zero' do
                expect(cart.total).to eq(0)
            end
        end

        context 'the cart has one item' do
            let!(:product) { FactoryBot.create(:product) }
            let(:cart) { Cart.new({ product.id => 1 }) } 
            
            it 'returns the correct total' do 
                expect(cart.total).to eq(product.price_in_cents)
            end 
        end

        context 'the cart has multiple items' do
            let(:product1) { FactoryBot.create(:product, price_in_cents: 100) }
            let(:product2) { FactoryBot.create(:product, price_in_cents: 200)}

            context 'with one of each item' do 
                let(:cart) { Cart.new({ product1.id => 1, product2.id => 1})}

                it 'returns the correct total' do
                    expect(cart.total).to  eq(300)
                end
            end 

            context 'with multiple of each item' do
                let(:cart) { Cart.new({ product1.id => 2, product2.id => 4})}

                it 'returns the correct total' do
                    expect(cart.total).to eq(1_000)
                end
            end
        end
    end

    describe '#line_items' do
        context 'the cart is empty' do
            let(:cart) { Cart.new({}) }

            it 'returns an empty Array' do
                expect(cart.line_items).to eq([])
            end
        end

        context 'the cart has one item' do
            let(:cart) { Cart.new({1 => 1})}

            it 'returns an array with one item' do 
                expect(cart.line_items.length).to eq(1)
            end
        end

        context 'the cart has many items' do
            let(:cart) { Cart.new({1 => 1, 2 => 1, 3 => 1})}

            it 'returns an array with the correct number of items' do 
                expect(cart.line_items.length).to eq(3)
            end
        end

        context 'the cart contains multiple of the same item' do
            let(:cart) { Cart.new({1 => 3, 2 => 2, 3 => 3})}

            it 'returns an array with the correct number of items' do 
                expect(cart.line_items.length).to eq(3)
            end
        end
    end

    describe '#add_by_id' do
        let(:cart) {Cart.new({})}

        it 'returns a Cart::LineItem' do
            expect(cart.add_by_id(1)).to be_a(Cart::LineItem)
        end

        context 'the cart does not contain this item' do
            let(:cart) {Cart.new({})}

            it 'sets the quantity to one' do
                expect(cart.add_by_id(1).quantity).to eq(1)
            end
        end

        context 'the cart contains this item' do
            let(:cart) {Cart.new({1 => 1})}

            it 'increments the quantity by one' do
                expect(cart.add_by_id(1).quantity).to eq(2)
            end

            it 'does not create a new item' do
                line_item_count = cart.line_items.length
                cart.add_by_id(1)
                expect(cart.line_items.length).to eq(line_item_count)
            end
        end
    end

    describe '#to_h' do
        context 'the cart is empty' do
            let(:cart) { Cart.new({}) }

            it 'returns a Hash' do
                expect(cart.to_h).to be_a(Hash)
            end

            it 'returns an empty Hash' do
                expect(cart.to_h.length).to eq(0)
            end
        end

        context 'the cart has one line item' do
            let(:cart) { Cart.new({ 1 => 1 }) }

            it 'returns a hash with length one' do
                expect(cart.to_h.length).to eq(1)
            end

            it 'returns the correct Hash' do
                expect(cart.to_h).to eq({1 => 1})
            end
        end

        context 'the cart has multiple line items with multiple quantity' do
            let(:cart) { Cart.new({ 1 => 4, 2 => 2, 3 => 5 }) }

            it 'returns a hash with length three' do
                expect(cart.to_h.length).to eq(3)
            end

            it 'returns the correct Hash' do
                expect(cart.to_h).to eq({ 1 => 4, 2 => 2, 3 => 5 })
            end
        end
    end
end