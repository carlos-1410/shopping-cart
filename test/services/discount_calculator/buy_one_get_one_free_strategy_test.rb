# frozen_string_literal: true

require "test_helper"

module DiscountCalculator
  class BuyOneGetOneFreeStrategyTest < ActiveSupport::TestCase
    setup do
      @product = create(:product)
    end

    test "no discount when quantity is negative" do
      assert_discount(quantity: -10, expected_discount: 0)
    end

    test "no discount when quantity is 0" do
      assert_discount(quantity: 0, expected_discount: 0)
    end

    test "with 1 product there's no discount" do
      assert_discount(quantity: 1, expected_discount: 0)
    end

    test "with 2 products 1 is free" do
      assert_discount(quantity: 2, expected_discount: @product.price)
    end

    test "with 3 products 1 is free" do
      assert_discount(quantity: 3, expected_discount: @product.price)
    end

    test "with 4 products 2 are free" do
      assert_discount(quantity: 4, expected_discount: @product.price * 2)
    end

    test "with 5 products 2 are free" do
      assert_discount(quantity: 5, expected_discount: @product.price * 2)
    end

    private

    def assert_discount(quantity:, expected_discount:)
      product = @product
      discount_rule = create(:discount_rule, :buy_one_get_one_free_discount, product:)

      result = BuyOneGetOneFreeStrategy.new(product:, quantity:, discount_rule:).call

      assert_equal result, expected_discount
    end
  end
end