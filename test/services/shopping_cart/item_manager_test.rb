# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  class ItemManagerTest < ActiveSupport::TestCase
    setup do
      @cart = Cart.create
      @product = create(:product)
    end

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
  end
end
