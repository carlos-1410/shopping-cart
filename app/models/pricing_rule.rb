# frozen_string_literal: true

class PricingRule < ApplicationRecord
  STATUSES = [
    ACTIVE_STATUS = "active",
    INACTIVE_STATUS = "inactive"
  ].freeze

  DISCOUNT_TYPES = [
    BUY_ONE_GET_ONE_FREE_DISCOUNT = "buy_one_get_one_free",
    PERCENTAGE_DISCOUNT = "percentage",
    PRICE_DISCOUNT = "price"
  ].freeze

  belongs_to :product

  validate :validate_status, on: %i(create update), if: -> { product.present? }

  with_options presence: true do
    validates :product
    validates :discount_type, inclusion: { in: DISCOUNT_TYPES }
    validates :status, inclusion: { in: STATUSES }
  end

  with_options presence: true, unless: :buy_one_get_one_free? do
    validates :min_amount, numericality: { greater_than_or_equal: 0 }
    validates :discount_amount, numericality: { greater_than: 0 }
  end

  # No point to have more than one discount of this type
  validates :discount_type, uniqueness: { scope: :product_id }, if: :buy_one_get_one_free?

  before_save :clear_amounts

  def buy_one_get_one_free?
    discount_type == BUY_ONE_GET_ONE_FREE_DISCOUNT
  end

  private

  def validate_status
    return true if status == INACTIVE_STATUS

    active_pricing_rule = product.active_pricing_rule
    return true if active_pricing_rule.blank? || active_pricing_rule == self

    errors.add :status, "Only 1 active pricing rule per product allowed"
  end

  def clear_amounts
    return unless buy_one_get_one_free?

    self.min_amount = 0
    self.discount_amount = 0
  end
end
