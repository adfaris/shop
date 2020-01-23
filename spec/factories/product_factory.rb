FactoryBot.define do
    factory :product do
      name { "Laptop" }
      body  { '13" slim and light weight' }
      price_in_cents { 100_000 }
    end
end