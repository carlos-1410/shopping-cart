# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.timestamps
    end
  end
end
