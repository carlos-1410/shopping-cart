class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, null: false, default: 0
      t.decimal :total_price, null: false, precision: 10, scale: 2
      t.decimal :discount_amount, precision: 5, scale: 2
      t.string :discounts_applied, array: true
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :cart, null: false, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
