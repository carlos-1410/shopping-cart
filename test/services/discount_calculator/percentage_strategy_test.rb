# frozen_string_literal: true

require "test_helper"

module DiscountCalculator
  class PercentageStrategyTest < ActiveSupport::TestCase
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
      discount_amount = 300
      expected_discount = (@product.price * quantity) * discount_amount / 1000

      assert_discount(quantity: 2, expected_discount: expected_discount,
                      discount_amount: discount_amount)
    end

    private

    def assert_discount(quantity:, expected_discount:, discount_amount: 1)
      product = @product
      discount_rule = create(:discount_rule, :percentage_discount,
                             min_quantity: 2, amount: discount_amount, product: product)

      result = PercentageStrategy.new(product:, quantity:, discount_rule:).call

      assert_equal expected_discount.ceil(2), result
    end
  end
end
