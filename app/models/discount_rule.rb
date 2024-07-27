# frozen_string_literal: true

class DiscountRule < ApplicationRecord
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

  with_options presence: true do
    validates :product
    validates :discount_type, inclusion: { in: DISCOUNT_TYPES }
    validates :status, inclusion: { in: STATUSES }
  end

  with_options presence: true, unless: :buy_one_get_one_free? do
    validates :min_quantity, numericality: { greater_than_or_equal: 0 }
    validates :amount, numericality: { greater_than: 0 }
  end

  # No point to have more than one discount of this type
  validates :discount_type, uniqueness: { scope: :product_id }, if: :buy_one_get_one_free?

  before_save :set_amounts, if: :buy_one_get_one_free?

  def active?
    status == ACTIVE_STATUS
  end

  def buy_one_get_one_free?
    discount_type == BUY_ONE_GET_ONE_FREE_DISCOUNT
  end

  private

  def set_amounts
    self.min_quantity = 2
    self.amount = 0
  end
end
