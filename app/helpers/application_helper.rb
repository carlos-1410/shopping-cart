# frozen_string_literal: true

module ApplicationHelper
  def discount_amount(discount_rule)
    case discount_rule.discount_type
    when DiscountRule::PERCENTAGE_DISCOUNT
      "#{discount_rule.amount}%"
    when DiscountRule::PRICE_DISCOUNT
      "#{discount_rule.amount}€"
    else
      "n/a"
    end
  end
end
