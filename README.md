# Shopping cart app

## Setting up the environment
1. Get Ruby `3.3.3`
2. `bundle install`
3. `rails db:create && rails db:migrate && rails db:seed`

## Discount rules

Each product can have zero or more discount rules.

`DiscountRule` attributes
- `type` - type of discount based on which we calculate the product group price.
- `amount` - amount of discount in cash/percent, depending on `type`. Always greater than `0`.
- `min_quantity` - minimum product quantity from which the discount is applied. Greater than or equal to `0` (we may want to discount the product regardless of its amount)
- `status` - status of the rule `active | inactive`. Each product can have exactly `1` active pricing rule.

There are 3 `type`s to choose from for the `DiscountRule`:
- `buy_one_get_one_free` - every other product is free of charge. `min_quantity` and `amount` are not taken into account during the calculation
- `price` - price discount on every product
- `percentage` - percentage discount on every product
