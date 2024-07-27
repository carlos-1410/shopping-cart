# frozen_string_literal: true

module ShoppingCart
  module Items
    class Destroy
      def initialize(cart:, product:)
        @cart = cart
        @product = product
      end

      def call
        cart_item.destroy_with_response
      end

      private

      attr_reader :cart, :product

      def cart_item
        @cart_item ||= cart.cart_items.find_by(product_id: product.id)
      end
    end
  end
end
