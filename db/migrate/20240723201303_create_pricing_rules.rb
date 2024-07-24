# frozen_string_literal: true

class CreatePricingRules < ActiveRecord::Migration[7.0]
  def change
    create_table :pricing_rules do |t|
      t.string :discount_type, null: false
      t.integer :min_amount, null: false, default: 0
      t.decimal :discount_amount, null: false, precision: 5, scale: 2
      t.string :status, null: false
      t.belongs_to :product, null: false, foreign_key: true
      t.timestamps
    end
  end
end
