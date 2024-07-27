# frozen_string_literal: true

module ShoppingCart
  module Items
    class Update < Create
      def initialize(cart:, cart_item:, quantity: 0) # rubocop:disable Lint/MissingSuper
        @cart = cart
        @cart_item = cart_item
        @quantity = quantity
      end

      def call
        if quantity.positive?
          cart_item.save_with_response(quantity:, total_price:, discount_amount:)
        else
          ShoppingCart::Items::Destroy.new(cart:, product:).call
        end
      end

      private

      attr_reader :cart, :cart_item

      def quantity
        cart_item.present? ? cart_item.quantity + @quantity : @quantity
      end

      def product
        @product ||= cart_item.product
      end
    end
  end
end
