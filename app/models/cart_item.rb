# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  with_options presence: true do
    validates :quantity, numericality: { greater_than: 0 }
    validates :total_price
  end

  def discounts_applied
    active_discount_rules = product.active_discount_rules
      .select { discount_applicable?(_1) }
      .map(&:discount_type)

    return ["-"] if active_discount_rules.empty?

    active_discount_rules
  end

  private

  def discount_applicable?(discount_rule)
    quantity >= discount_rule.min_quantity
  end
end
