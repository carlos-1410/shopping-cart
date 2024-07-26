# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, :total_price, presence: true

  def discounts_applied
    product.active_discount_rules
      .select{ discount_applicable?(_1) }
      .map(&:discount_type)
  end

  private

  def discount_applicable?(discount_rule)
    return true if discount_rule.buy_one_get_one_free?

    quantity >= discount_rule.min_quantity
  end
end
