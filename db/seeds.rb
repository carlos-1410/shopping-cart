green_tea = Product.find_or_create_by!(name: "Green tea", code: "GR1", price: 3.11)
strawberries = Product.find_or_create_by!(name: "Strawberries", code: "SR1", price: 5.00)
coffee = Product.find_or_create_by!(name: "Coffee", code: "CF1", price: 11.23)

PricingRule.find_or_create_by!(
  discount_type: PricingRule::BUY_ONE_GET_ONE_FREE_DISCOUNT,
  status: PricingRule::ACTIVE_STATUS,
  product: green_tea
) # in this case min_amount and discount_amount are ignored
PricingRule.find_or_create_by!(
  discount_type: PricingRule::PRICE_DISCOUNT,
  min_amount: 3,
  discount_amount: 0.5,
  status: PricingRule::ACTIVE_STATUS,
  product: strawberries
)
PricingRule.find_or_create_by!(
  discount_type: PricingRule::PERCENTAGE_DISCOUNT,
  min_amount: 3,
  discount_amount: 0.33,
  status: PricingRule::ACTIVE_STATUS,
  product: coffee
)
