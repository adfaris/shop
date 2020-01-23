# require 'rails_helper'

# RSpec.describe Product, type: :model do

#   describe '.laptops' do
#     context 'we have laptops for sale' do
#       FactoryBot.create(:product, category:"laptop")

#       it 'returns a array' do
#         expect(Product.laptops).to be_an(Array)
#       end

#       it 'is non-empty' do
#         expect(Product.laptops.length).to.not eq(0)
#       end

#       it 'does not return desktops' do
#         expect(Product.laptops.contains?(:desktop)).to be_false
#       end
#     end

#     context 'we have no laptops for sale' do
#       it 'returns an empty array'
#     end
    
#     context 'the laptops are for sale but are backordered' do
#       it 'returns a non-empty array'
#       it 'does not return desktops'
#     end
#   end
# end

# class Product
#   def self.laptops
#     where(category: 'laptop').where.not(stock: 0)
#   end
