# frozen_string_literal: true

FactoryBot.define do
  factory :pricing_rule do
    trait :price_discount do
      discount_type { PricingRule::PRICE_DISCOUNT }
      min_quantity { 2 }
      discount_amount { 0.5 }
      status { PricingRule::ACTIVE_STATUS }
      product { create(:product) }
    end

    trait :percentage_discount do
      discount_type { PricingRule::PERCENTAGE_DISCOUNT }
      min_quantity { 2 }
      discount_amount { 0.5 }
      status { PricingRule::ACTIVE_STATUS }
      product { create(:product) }
    end

    trait :buy_one_get_one_free_discount do
      discount_type { PricingRule::BUY_ONE_GET_ONE_FREE_DISCOUNT }
      status { PricingRule::ACTIVE_STATUS }
      product { create(:product) }
    end
  end
end
