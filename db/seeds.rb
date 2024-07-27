green_tea = Product.find_or_create_by!(name: "Green tea", code: "GR1", price: 311)
strawberries = Product.find_or_create_by!(name: "Strawberries", code: "SR1", price: 500)
coffee = Product.find_or_create_by!(name: "Coffee", code: "CF1", price: 1123)

DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::BUY_ONE_GET_ONE_FREE_DISCOUNT, 
  status: DiscountRule::ACTIVE_STATUS,
  product: green_tea
) # in this case min_quantity and amount are ignored
DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::PRICE_DISCOUNT,
  min_quantity: 3,
  amount: 50,
  status: DiscountRule::ACTIVE_STATUS,
  product: strawberries
)
DiscountRule.find_or_create_by!(
  discount_type: DiscountRule::PERCENTAGE_DISCOUNT,
  min_quantity: 3,
  amount: 330,
  status: DiscountRule::ACTIVE_STATUS,
  product: coffee
)
