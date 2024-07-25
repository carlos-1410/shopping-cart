# frozen_string_literal: true

module ApplicationHelper
  def discount_amount(pricing_rule)
    case pricing_rule.discount_type
    when PricingRule::PERCENTAGE_DISCOUNT
      "#{pricing_rule.discount_amount}%"
    when PricingRule::PRICE_DISCOUNT
      "#{pricing_rule.discount_amount}€"
    else
      "n/a"
    end
  end

  def minimum_amount(pricing_rule)
    case pricing_rule.discount_type
    when PricingRule::BUY_ONE_GET_ONE_FREE_DISCOUNT
      "n/a"
    else
      pricing_rule.min_quantity
    end
  end
end
