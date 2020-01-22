require 'rails_helper'

RSpec.describe 'Homepage', type: :feature do
it('redirect to products_path') do
        visit root_path
        expect(page.current_path).to eq(products_path)
    end 
end