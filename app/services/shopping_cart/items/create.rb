# frozen_string_literal: true

module ShoppingCart
  module Items
    class Create
      def initialize(cart:, product:, quantity: 0)
        @cart = cart
        @product = product
        @quantity = quantity
      end

      def call
        new_cart_item = cart.cart_items.create(product:, quantity:, total_price:, discount_amount:,
                                               discounts_applied:)

        if new_cart_item.persisted?
          Response.success(new_cart_item)
        else
          Response.failure(new_cart_item.errors.full_messages.to_sentence)
        end
      end

      private

      attr_reader :cart, :product, :quantity

      def discount_amount
        active_discount_rules.map do |discount_rule|
          DiscountCalculator::Manager.new(product:, quantity:, discount_rule:).call
        end.sum
      end

      def discounts_applied
        active_discount_rules.select { discount_applicable?(_1) }.map(&:discount_type)
      end

      def total_price
        return 0 if discount_amount > cart_item_price

        cart_item_price - discount_amount
      end

      def cart_item_price
        (product.price * quantity).ceil(2)
      end

      def discount_applicable?(discount_rule)
        quantity >= discount_rule.min_quantity
      end

      def active_discount_rules
        @active_discount_rules ||= product.active_discount_rules
      end
    end
  end
end
