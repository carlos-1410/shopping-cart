# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module Items
    class CreateTest < ActiveSupport::TestCase
      setup do
        @cart = Cart.create
        @product = create(:product)
      end

      test "create fails" do
        assert_no_difference -> { CartItem.count } do
          response = Create.new(cart: @cart, product: @product, quantity: 0).call
          expected_error = "Quantity must be greater than 0"

          assert response.is_a?(Response)
          assert response.failure?
          assert_equal expected_error, response.value
        end
      end

      test "create a new cart_item without discount" do
        assert_difference -> { CartItem.count }, +1 do
          response = Create.new(cart: @cart, product: @product, quantity: 1).call

          assert response.success?
          assert_equal 0, response.value.discount_amount
        end
      end

      test "create a new cart_item with price_discount" do
        assert_difference -> { CartItem.count }, +1 do
          discount_rule = create(:discount_rule, :price_discount, product: @product,
                                                                  min_quantity: 1)

          response = Create.new(cart: @cart, product: @product, quantity: 1).call

          assert response.success?
          assert_equal discount_rule.amount, response.value.discount_amount
        end
      end

      test "create a new cart_item with percentage_discount" do
        assert_difference -> { CartItem.count }, +1 do
          quantity = 1
          discount_rule = create(:discount_rule, :percentage_discount, product: @product,
                                                                       min_quantity: 1)
          expected_discount_amount =
            ((@product.price * quantity) * discount_rule.amount / 100).ceil(2)

          response = Create.new(cart: @cart, product: @product, quantity: quantity).call

          assert response.success?
          assert_equal expected_discount_amount, response.value.discount_amount
        end
      end

      test "create a new cart_item with all the discounts" do
        assert_difference -> { CartItem.count }, +1 do
          quantity = 5
          price_discount_amount = 0.5
          percentage_discount_amount = 33
          expected_bogof_discount_amount = (quantity / 2) * @product.price
          expected_price_discount_amount = price_discount_amount * quantity
          expected_percentage_discount_amount =
            (@product.price * quantity) * percentage_discount_amount / 100
          expected_discount_amount = [expected_bogof_discount_amount,
                                      expected_price_discount_amount,
                                      expected_percentage_discount_amount].sum.ceil(2)

          create(:discount_rule, :price_discount, product: @product, min_quantity: 1,
                                                  amount: price_discount_amount)
          create(:discount_rule, :percentage_discount, product: @product, min_quantity: 1,
                                                       amount: percentage_discount_amount)
          create(:discount_rule, :buy_one_get_one_free_discount, product: @product)

          response = Create.new(cart: @cart, product: @product, quantity: quantity).call

          assert response.success?
          assert_equal expected_discount_amount, response.value.discount_amount
        end
      end
    end
  end
end
