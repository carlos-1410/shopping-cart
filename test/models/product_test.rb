# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "invalid when required attributes are missing" do
    product = build(:product, code: nil, name: nil, price: nil)

    assert product.invalid?

    %i(code name price).each do |field|
      assert product.errors.added?(field, :blank)
    end
  end

  test "invalid when price is not a number" do
    invalid_price = "invalid"
    product = build(:product, price: invalid_price)

    assert product.invalid?
    assert product.errors.added?(:price, :not_a_number, value: invalid_price)
  end

  test "has an active_pricing_rule" do
    product = create(:product)
    pricing_rule = create(:pricing_rule, :price_discount, product:)
    product.reload

    assert_equal product.active_pricing_rule, pricing_rule
  end

  test "valid product" do
    product = build(:product)
    assert product.valid?
  end
end
