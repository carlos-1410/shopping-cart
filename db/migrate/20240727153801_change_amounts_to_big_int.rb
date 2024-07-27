class ChangeAmountsToBigInt < ActiveRecord::Migration[7.0]
  def up
    change_column :products, :price, :bigint
    change_column :discount_rules, :amount, :integer
    change_column :cart_items, :total_price, :bigint
    change_column :cart_items, :discount_amount, :bigint
  end

  def down
    change_column :products, :price, :decimal
    change_column :discount_rules, :amount, :decimal
    change_column :cart_items, :total_price, :decimal
    change_column :cart_items, :discount_amount, :decimal
  end
end
