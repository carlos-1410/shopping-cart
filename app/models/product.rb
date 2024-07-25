# frozen_string_literal: true

class Product < ApplicationRecord
  # rubocop:disable Rails/HasManyOrHasOneDependent, Rails/InverseOf
  has_one :active_pricing_rule,
          -> { PricingRule.where(status: PricingRule::ACTIVE_STATUS) },
          class_name: "PricingRule"
  has_many :pricing_rules, dependent: :delete_all
  # rubocop:enable Rails/HasManyOrHasOneDependent, Rails/InverseOf

  with_options presence: true do
    validates :code, :name, :price
    validates :price, numericality: { greater_than: 0 }
  end
end
