require 'rails_helper'

RSpec.describe Cart, type: :model do
    describe '.new' do
        context 'valid arguments' do
            it 'does not raise an exception' do
                expect { Cart.new({1 => 1}, 0.1) }.not_to raise_exception
            end
        end

        context 'invalid arguments' do
            context 'items is not a Hash' do
                it 'raises an ArgumentError' do
                    expect { Cart.new("string") }.to raise_exception(ArgumentError)
                end
            end

            context 'discount is not a Float' do
                it 'raises an ArgumentError' do
                    expect { Cart.new({}, "not a float") }.to raise_exception(ArgumentError)
                end
            end
        end
    end

    # ClassName.total class method class#total instance method
    describe '#subtotal' do
        context 'the cart is empty' do
            let(:cart) { Cart.new({}) } 

            it 'returns zero' do
                expect(cart.subtotal).to eq(0)
            end
        end

        context 'the cart has one item' do
            let!(:product) { FactoryBot.create(:product) }
            let(:cart) { Cart.new({ product.id => 1 }) } 
            
            it 'returns the correct total' do 
                expect(cart.subtotal).to eq(product.price_in_cents)
            end 
        end

        context 'the cart has multiple items' do
            let(:product1) { FactoryBot.create(:product, price_in_cents: 100)}
            let(:product2) { FactoryBot.create(:product, price_in_cents: 200)}

            context 'with one of each item' do 
                let(:cart) { Cart.new({ product1.id => 1, product2.id => 1})}

                it 'returns the correct total' do
                    expect(cart.subtotal).to  eq(300)
                end
            end 

            context 'with multiple of each item' do
                let(:cart) { Cart.new({ product1.id => 2, product2.id => 4})}

                it 'returns the correct total' do
                    expect(cart.subtotal).to eq(1_000)
                end
            end
        end
    end

    describe '#total' do
        context 'the  cart is empty' do
            let(:cart) { Cart.new({}) }

            it 'returns zero' do
                expect(cart.total).to be(0)
            end
        end

        context 'the cart has one item' do
            let!(:product) { FactoryBot.create(:product, price_in_cents: 100) }
            
            context 'there is no discount applied' do
                let(:cart) { Cart.new({ product.id => 1}) }

                it 'returns the correct total' do
                    expect(cart.total).to eq(100)
                end
            end

            context 'there is a 20% off discount applied' do
                let(:cart) { Cart.new({ product.id => 1}, 0.2) }

                it 'returns the correct total after discount' do
                    expect(cart.total).to eq(80)
                end
            end
        end

        context 'the cart has multiple items' do
            let!(:product1) { FactoryBot.create(:product, price_in_cents: 1_000)}
            let!(:product2) { FactoryBot.create(:product, price_in_cents: 2_000)}
            
            context 'there is no discount applied' do
                context 'with one of each each item' do
                    let(:cart) { Cart.new( { product1.id => 1, product2.id => 1 }) }
                    
                    it 'returns the correct total' do
                        expect(cart.total).to eq(3_000)
                    end
                end 
    
                context 'with multiple of each item' do
                    let(:cart) { Cart.new({ product1.id => 2, product2.id => 4})}
    
                    it 'returns the correct total' do
                        expect(cart.total).to eq(10_000)
                    end
                end                       
            end

            context 'there is a 20% off discount applied' do
                context 'with one of each each item' do
                    let(:cart) { Cart.new( { product1.id => 1, product2.id => 1 }, 0.2) }
                    
                    it 'returns the correct total' do
                        expect(cart.total).to eq(2_400)
                    end
                end 
    
                context 'with multiple of each item' do
                    let(:cart) { Cart.new({ product1.id => 2, product2.id => 4}, 0.2)}
    
                    it 'returns the correct total' do
                        expect(cart.total).to eq(8_000)
                    end
                end   
            end
        end
    end

    describe '#discount' do
        let!(:product) { FactoryBot.create(:product, price_in_cents: 1_000) }

        context 'the cart has a discount applied' do
            let(:cart) { Cart.new({ product.id => 1 }, 0.2) }

            it 'returns the correct discount' do
                expect(cart.discount).to eq(200)
            end
        end

        context 'the cart has no discount applied' do
            let(:cart) { Cart.new({ product.id => 1 }) }

            it 'returns zero' do
                expect(cart.discount).to eq(0)
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

    describe '#remove_by_id' do
        context 'the cart does not contain the item being removed' do
            let(:cart) { Cart.new({})}

            it 'returns nil' do
                expect(cart.remove_by_id(1)).to eq(nil)
            end
        end

        context 'the cart contains exactly one of the item being removed' do
            let(:id)   { 1 }
            let(:cart) { Cart.new({id => 1}) }

            before do
                @return_value = cart.remove_by_id(id)
            end

            it 'removes the item from the cart' do
                expect(cart.to_h[id]).to eq(nil)
            end
            
            it 'returns the removed Cart::LineItem' do
                expect(@return_value).to be_a(Cart::LineItem)
            end
        end

        context 'the cart contains many of the item being removed' do
            let(:id)    { 1 }
            let!(:cart) { Cart.new({id => 5}) }

            before do
                @return_value = cart.remove_by_id(id)
            end

            it 'removes the item from the cart' do
                expect(cart.to_h[id]).to eq(nil)
            end

            it 'returns the removed Cart::LineItem' do 
                expect(@return_value).to be_a(Cart::LineItem)
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

    describe '#totals' do
        context 'the cart contains multiple quantity of multiple items' do
            let!(:product1) { FactoryBot.create(:product, price_in_cents: 1_000)}
            let!(:product2) { FactoryBot.create(:product, price_in_cents: 2_000)}
            let(:cart) { Cart.new({ product1.id => 2, product2.id => 4}, 0.2)}

            context 'valid arguments' do
                context 'request subtotal' do
                    it 'returns the correct price' do
                        expect(cart.totals(:subtotal).to_s).to eq('$100.00')                                         
                    end
                end

                context 'request discount' do
                    it 'returns the correct price' do
                        expect(cart.totals(:discount).to_s).to eq('$20.00')                    
                    end
                end

                context 'request total' do
                    it 'returns the correct price' do
                      expect(cart.totals(:total).to_s).to eq('$80.00')
                    end                                      
                end
            end

            context 'invalid arguments' do
                it 'raises an error' do
                   expect { cart.totals(:invalid) }.to raise_exception(ArgumentError) 
                end
            end
        end
    end
end