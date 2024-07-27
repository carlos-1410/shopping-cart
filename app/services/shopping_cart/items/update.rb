# frozen_string_literal: true

module ShoppingCart
  module Items
    class Update
      def initialize(cart:, cart_item:, quantity: 0)
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

      def discount_amount
        product.active_discount_rules.map do |discount_rule|
          DiscountCalculator::Manager.new(product:, quantity:, discount_rule:).call
        end.sum
      end

      def quantity
        cart_item.present? ? cart_item.quantity + @quantity : @quantity
      end

      def total_price
        return 0 if discount_amount > cart_item_price

        cart_item_price - discount_amount
      end

      def cart_item_price
        (product.price * quantity).ceil(2)
      end

      def product
        @product ||= cart_item.product
      end
    end
  end
end
