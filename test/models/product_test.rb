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

  test "invalid when price is not greater than 0" do
    product = build(:product, price: -10)

    assert product.invalid?
  end

  test "has active_discount_rules" do
    product = create(:product)
    discount_rule = create(:discount_rule, :price_discount, product:)
    product.reload

    assert product.active_discount_rules.any?
    assert_equal 1, product.active_discount_rules.size
    assert_includes product.active_discount_rules.map(&:id), discount_rule.id
  end

  test "invalid when code is not unique" do
    code = "code"
    create(:product, code:)
    invalid_product = build(:product, code:)

    assert invalid_product.invalid?
    assert invalid_product.errors.added?(:code, :taken, value: code)
  end

  test "valid product" do
    product = build(:product)
    assert product.valid?
  end
end
