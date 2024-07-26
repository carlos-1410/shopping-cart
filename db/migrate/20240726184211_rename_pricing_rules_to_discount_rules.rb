class RenamePricingRulesToDiscountRules < ActiveRecord::Migration[7.0]
  def change
    rename_table :pricing_rules, :discount_rules
    rename_column :discount_rules, :discount_amount, :amount
  end
end
