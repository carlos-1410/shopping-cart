# frozen_string_literal: true

module ShoppingCart
  module Items
    class Upsert
      def initialize(cart:, product:, quantity: 0)
        @cart = cart
        @product = product
        @quantity = quantity.to_i
      end

      def call
        if cart_item.present?
          ShoppingCart::Items::Update.new(cart:, cart_item:, quantity:).call
        else
          return Response.failure("Invalid quantity") if quantity <= 0

          ShoppingCart::Items::Create.new(cart:, product:, quantity:).call
        end
      end

      private

      attr_reader :cart, :product, :quantity

      def cart_item
        @cart_item ||= cart.cart_items.find_by(product_id: product.id)
      end
    end
  end
end
