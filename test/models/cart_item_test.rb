# frozen_string_literal: true

require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  test "required attributes" do
    cart_item = build(:cart_item, product: nil, cart: nil, quantity: nil, total_price: nil)

    assert cart_item.invalid?

    %i(product cart quantity total_price).each do |field|
      assert cart_item.errors.added?(field, :blank)
    end
  end

  test "valid cart_item" do
    cart_item = build(:cart_item)

    assert cart_item.valid?
  end
end
