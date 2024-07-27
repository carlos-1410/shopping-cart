# frozen_string_literal: true

module DiscountCalculator
  class Manager
    def initialize(product:, quantity:, discount_rule:)
      @product = product
      @quantity = quantity
      @discount_rule = discount_rule
    end

    def call
      return product_price unless discount_rule.active?

      calculate_discount
    end

    private

    attr_reader :product, :quantity, :discount_rule

    def product_price
      product.price * quantity
    end

    def calculate_discount
      discount_strategy_class.new(product:, quantity:, discount_rule:).call
    end

    def discount_strategy_class
      case discount_rule.discount_type
      when DiscountRule::BUY_ONE_GET_ONE_FREE_DISCOUNT
        BuyOneGetOneFreeStrategy
      when DiscountRule::PERCENTAGE_DISCOUNT
        PercentageStrategy
      when DiscountRule::PRICE_DISCOUNT
        PriceStrategy
      else
        raise NotImplementedError, "Unsupported discount_type"
      end
    end
  end
end
