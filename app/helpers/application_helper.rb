# frozen_string_literal: true

module ApplicationHelper
  def discount_amount(discount_rule)
    case discount_rule.discount_type
    when DiscountRule::PERCENTAGE_DISCOUNT
      "#{discount_rule.amount / 10}%"
    when DiscountRule::PRICE_DISCOUNT
      "#{cents_to_amount discount_rule.amount}€"
    else
      "n/a"
    end
  end

  def cents_to_amount(amount)
    return if amount.nil?

    amount.to_d / 100
  end
end
