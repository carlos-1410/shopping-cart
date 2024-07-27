# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module Items
    class ManagerTest < ActiveSupport::TestCase
      setup do
        @cart = Cart.create
        @product = create(:product)
      end

      test "calls update class when item_in_cart? is truthy" do
        quantity = 1
        cart_item = create(:cart_item, cart: @cart, product: @product)
        args = { cart: @cart, cart_item: cart_item, quantity: quantity }

        items_manager_mock = mock
        items_manager_mock.expects(:call)
        ShoppingCart::Items::Update.expects(:new).with(**args).returns(items_manager_mock)

        Manager.new(cart: @cart, product: @product, quantity: quantity).call
      end

      test "calls create class when item_in_cart? is falsy" do
        quantity = 1
        args = { cart: @cart, product: @product, quantity: quantity }

        items_manager_mock = mock
        items_manager_mock.expects(:call)
        ShoppingCart::Items::Create.expects(:new).with(**args).returns(items_manager_mock)

        Manager.new(cart: @cart, product: @product, quantity: quantity).call
      end

      test "returns failure when quantity is invalid" do
        response = Manager.new(cart: @cart, product: @product, quantity: "invalid").call

        assert response.is_a?(Response)
        assert_equal "Invalid quantity", response.value
      end
    end
  end
end
