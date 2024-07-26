# frozen_string_literal: true

class Product < ApplicationRecord
  # rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
  has_many :active_discount_rules,
          -> { DiscountRule.where(status: DiscountRule::ACTIVE_STATUS) },
          class_name: "DiscountRule"
  has_many :discount_rules, dependent: :delete_all
  # rubocop:enable Rails/HasManyOrHasOneDependent, Rails/InverseOf

  with_options presence: true do
    validates :code, :name, :price
    validates :price, numericality: { greater_than: 0 }
  end
end
