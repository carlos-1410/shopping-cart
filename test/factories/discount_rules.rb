# frozen_string_literal: true

FactoryBot.define do
  factory :discount_rule do
    trait :price_discount do
      discount_type { DiscountRule::PRICE_DISCOUNT }
      min_quantity { 2 }
      amount { 0.5 }
      status { DiscountRule::ACTIVE_STATUS }
      product { create(:product) }
    end

    trait :percentage_discount do
      discount_type { DiscountRule::PERCENTAGE_DISCOUNT }
      min_quantity { 2 }
      amount { 5 }
      status { DiscountRule::ACTIVE_STATUS }
      product { create(:product) }
    end

    trait :buy_one_get_one_free_discount do
      discount_type { DiscountRule::BUY_ONE_GET_ONE_FREE_DISCOUNT }
      status { DiscountRule::ACTIVE_STATUS }
      product { create(:product) }
    end
  end
end
