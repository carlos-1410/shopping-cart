# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module Items
    class UpdateTest < ActiveSupport::TestCase
      setup do
        @cart = Cart.create
        @product = create(:product)
      end

      test "destroys cart item when quantity is negative" do
        cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)

        assert_difference -> { CartItem.count }, -1 do
          response = Update.new(cart: @cart, cart_item: cart_item, quantity: -10).call

          assert response.is_a?(Response)
          assert response.success?
        end
      end

      test "updates a cart_item without discount" do
        cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
        response = Update.new(cart: @cart, cart_item: cart_item, quantity: 2).call

        assert response.success?
        assert_equal 3, response.value.quantity
      end

      test "updates a cart_item with price_discount" do
        quantity = 3
        discount_rule = create(:discount_rule, :price_discount, product: @product,
                                                                min_quantity: 1)
        cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
        expected_quantity = cart_item.quantity + quantity
        expected_discount_amount = (discount_rule.amount * expected_quantity).ceil(2)

        response = Update.new(cart: @cart, cart_item: cart_item, quantity: quantity).call

        assert response.success?
        assert_equal expected_discount_amount, response.value.discount_amount
        assert_equal expected_quantity, response.value.quantity
      end

      test "updates a new cart_item with percentage_discount" do
        quantity = 1
        discount_rule = create(:discount_rule, :percentage_discount, product: @product,
                                                                      min_quantity: 1)
        cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
        expected_quantity = cart_item.quantity + quantity
        expected_discount_amount =
          ((@product.price * expected_quantity) * discount_rule.amount / 1000).ceil(2)

        response = Update.new(cart: @cart, cart_item: cart_item, quantity: quantity).call

        assert response.success?
        assert_equal expected_discount_amount, response.value.discount_amount
        assert_equal expected_quantity, response.value.quantity
      end

      test "create a new cart_item with all the discounts" do
        assert_difference -> { CartItem.count }, +1 do
          quantity = 5
          expected_quantity = 6
          price_discount_amount = 5 # 0.5 Euro
          percentage_discount_amount = 33
          expected_bogof_discount_amount = (expected_quantity / 2) * @product.price
          expected_price_discount_amount = price_discount_amount * expected_quantity
          expected_percentage_discount_amount =
            (@product.price * expected_quantity) * percentage_discount_amount / 1000
          expected_discount_amount = [expected_bogof_discount_amount,
                                      expected_price_discount_amount,
                                      expected_percentage_discount_amount].sum.ceil(2)

          cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
          create(:discount_rule, :price_discount, product: @product, min_quantity: 1,
                                                  amount: price_discount_amount)
          create(:discount_rule, :percentage_discount, product: @product, min_quantity: 1,
                                                       amount: percentage_discount_amount)
          create(:discount_rule, :buy_one_get_one_free_discount, product: @product)

          response = Update.new(cart: @cart, cart_item: cart_item, quantity: quantity).call

          assert response.success?
          assert_equal expected_discount_amount, response.value.discount_amount
          assert_equal expected_quantity, response.value.quantity
        end
      end
    end
  end
end
