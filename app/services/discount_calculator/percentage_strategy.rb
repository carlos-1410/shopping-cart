# frozen_string_literal: true

module DiscountCalculator
  class PercentageStrategy
    def initialize(product:, quantity:, discount_rule:)
      @product = product
      @quantity = quantity
      @discount_rule = discount_rule
    end

    def call
      return 0 unless quantity >= discount_rule.min_quantity

      amount
    end

    private

    attr_reader :product, :quantity, :discount_rule

    def amount
      ((product.price * quantity) * discount_rule.amount / 100).ceil(2)
    end
  end
end
