green_tea = Product.find_or_create_by!(name: "Green tea", code: "GR1", price: 3.11)
strawberries = Product.find_or_create_by!(name: "Strawberries", code: "SR1", price: 5.00)
coffee = Product.find_or_create_by!(name: "Coffee", code: "CF1", price: 11.23)

DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::BUY_ONE_GET_ONE_FREE_DISCOUNT, 
  status: DiscountRule::ACTIVE_STATUS,
  product: green_tea
) # in this case min_quantity and amount are ignored
DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::PRICE_DISCOUNT,
  min_quantity: 3,
  amount: 0.5,
  status: DiscountRule::ACTIVE_STATUS,
  product: strawberries
)
DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::PERCENTAGE_DISCOUNT,
  min_quantity: 3,
  amount: 33,
  status: DiscountRule::ACTIVE_STATUS,
  product: coffee
)
