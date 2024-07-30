# frozen_string_literal: true

require "test_helper"

module ShoppingCart
  module Items
    class DestroyTest < ActiveSupport::TestCase
      setup do
        @cart = Cart.create
        @product = create(:product)
      end

      test "destroy succeeds" do
        create(:cart_item, cart: @cart, product: @product)

        assert_difference -> { CartItem.count }, -1 do
          response = Destroy.new(cart: @cart, product: @product).call

          assert response.success?
        end
      end

      test "destroy fails" do
        assert_no_difference -> { CartItem.count }, -1 do
          response = Destroy.new(cart: @cart, product: @product).call

          assert response.failure?
        end
      end
    end
  end
end
