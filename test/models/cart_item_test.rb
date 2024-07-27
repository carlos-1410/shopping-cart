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

  test "invalid when quantity is lower than or equal to 0" do
    cart_item = build(:cart_item, quantity: 0)
    assert cart_item.invalid?

    cart_item = build(:cart_item, quantity: -10)
    assert cart_item.invalid?
  end

  test "#discounts_applied" do
    product = create(:product)
    create(:discount_rule, :buy_one_get_one_free_discount, product:)
    create(:discount_rule, :percentage_discount, product: product, min_quantity: 1, amount: 1)
    create(:discount_rule, :price_discount, product: product, min_quantity: 1, amount: 1)
    cart_item = create(:cart_item, product: product, quantity: 2)
    expected_discount_types = DiscountRule::DISCOUNT_TYPES

    assert_equal cart_item.discounts_applied, expected_discount_types
  end

  test "valid cart_item" do
    cart_item = build(:cart_item)

    assert cart_item.valid?
  end
end
