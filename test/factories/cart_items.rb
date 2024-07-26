# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    product { create(:product) }
    cart { Cart.create }
    quantity { 2 }
    total_price { product.price * quantity }
  end
end
