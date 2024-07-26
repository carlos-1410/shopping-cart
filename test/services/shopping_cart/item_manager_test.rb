# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  class ItemManagerTest < ActiveSupport::TestCase
    setup do
      @cart = Cart.create
      @product = create(:product)
    end

    # Without any discount
    test "creates new cart_item" do
      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: 2)

      assert_difference -> { CartItem.count }, +1 do
        response = item_manager.call
        assert response.success?

        cart_item = CartItem.last
        assert_equal cart_item.product, @product
        assert_equal cart_item.total_price, @product.price * cart_item.quantity
      end
    end

    test "updates cart_item with positive quantity" do
      new_quantity = 2
      cart_item = create(:cart_item, cart: @cart, product: @product, quantity: 1)
      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: new_quantity)

      assert_no_difference -> { CartItem.count } do
        response = item_manager.call
        assert response.success?
        cart_item.reload

        assert_equal cart_item.quantity, new_quantity
        assert_equal cart_item.product, @product
        assert_equal cart_item.total_price, @product.price * cart_item.quantity
      end
    end

    test "destroys cart_item with 0 quantity" do
      create(:cart_item, cart: @cart, product: @product, quantity: 1)
      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: 0)

      assert_difference -> { CartItem.count }, -1 do
        response = item_manager.call
        assert response.success?
        assert CartItem.count.zero?
      end
    end

    test "destroys cart_item with negative quantity" do
      create(:cart_item, cart: @cart, product: @product, quantity: 1)
      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: -2)

      assert_difference -> { CartItem.count }, -1 do
        response = item_manager.call
        assert response.success?
        assert CartItem.count.zero?
      end
    end

    test "destroys cart_item when :remove was passed" do
      create(:cart_item, cart: @cart, product: @product, quantity: 1)
      item_manager = ItemManager.new(cart: @cart, product: @product, remove: true)

      assert_difference -> { CartItem.count }, -1 do
        response = item_manager.call
        assert response.success?
        assert CartItem.count.zero?
      end
    end

    test "fails when quantity is invalid" do
      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: 0)

      assert_no_difference -> { CartItem.count } do
        response = item_manager.call
        assert response.failure?
        assert_equal response.value, "Invalid quantity"
      end
    end

    # Discounted products
    test "percentage discounted product" do
      amount = 33 # 33 percent
      quantity = 3
      expected_discount_amount = @product.price * quantity * amount

      create(:discount_rule, :percentage_discount, product: @product, min_quantity: 1,
                                                   amount: amount)

      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: quantity)

      assert_difference -> { CartItem.count }, +1 do
        response = item_manager.call
        assert response.success?

        assert response.value.discount_amount, expected_discount_amount
      end
    end

    test "price discounted product" do
      amount = 0.5
      quantity = 3
      expected_discount_amount = (@product.price - amount) * quantity

      create(:discount_rule, :price_discount, product: @product, min_quantity: 1,
                                              amount: amount)

      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: quantity)

      assert_difference -> { CartItem.count }, +1 do
        response = item_manager.call
        assert response.success?

        assert response.value.discount_amount, expected_discount_amount
      end
    end

    test "buy_one_get_one_free discounted product" do
      quantity = 5
      expected_discount_amount = (quantity / 2) * @product.price

      create(:discount_rule, :buy_one_get_one_free_discount, product: @product)

      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: quantity)

      assert_difference -> { CartItem.count }, +1 do
        response = item_manager.call
        assert response.success?

        assert response.value.discount_amount, expected_discount_amount
      end
    end

    test "all discounts together" do
      quantity = 5
      price_discount_amount = 0.5
      percentage_discount_amount = 0.33
      expected_bogof_discount_amount = (quantity / 2) * @product.price
      expected_price_discount_amount = (@product.price - price_discount_amount) * quantity
      expected_percentage_discount_amount = @product.price * quantity * 0.33
      expected_discount_amount = [expected_bogof_discount_amount,
                                  expected_price_discount_amount,
                                  expected_percentage_discount_amount].sum

      create(:discount_rule, :price_discount, product: @product, min_quantity: 1,
                                              amount: price_discount_amount)
      create(:discount_rule, :percentage_discount, product: @product, min_quantity: 1,
                                                   amount: percentage_discount_amount)
      create(:discount_rule, :buy_one_get_one_free_discount, product: @product)

      item_manager = ItemManager.new(cart: @cart, product: @product, quantity: quantity)

      assert_difference -> { CartItem.count }, +1 do
        response = item_manager.call
        assert response.success?

        assert response.value.discount_amount, expected_discount_amount
      end
    end
  end
end
