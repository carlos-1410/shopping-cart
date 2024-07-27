# frozen_string_literal: true

require "test_helper"

module DiscountCalculator
  class PriceStrategyTest < ActiveSupport::TestCase
    setup do
      @product = create(:product)
    end

    test "no discount when quantity is negative" do
      assert_discount(quantity: -10, expected_discount: 0)
    end

    test "with 1 product there's no discount" do
      assert_discount(quantity: 1, expected_discount: 0)
    end

    test "with 2 products 30 discount" do
      quantity = 2
      discount_amount = 5 # 0.5 Euro
      expected_discount = discount_amount * quantity

      assert_discount(quantity: 2, expected_discount: expected_discount,
                      discount_amount: discount_amount)
    end

    private

    def assert_discount(quantity:, expected_discount:, discount_amount: 1)
      product = @product
      discount_rule = create(:discount_rule, :price_discount,
                             min_quantity: 2, amount: discount_amount, product: product)

      result = PriceStrategy.new(product:, quantity:, discount_rule:).call

      assert_equal result, expected_discount.ceil(2)
    end
  end
end
