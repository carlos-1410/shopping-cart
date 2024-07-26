# frozen_string_literal: true

module DiscountCalculator
  class BuyOneGetOneFreeStrategy
    def initialize(product:, quantity:, discount_rule: nil)
      @product = product
      @quantity = quantity
    end

    def call
      return 0 unless quantity > 1

      amount
    end

    private

    attr_reader :product, :quantity

    def amount
      (quantity / 2) * product.price
    end
  end
end
