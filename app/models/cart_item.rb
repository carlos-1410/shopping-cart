# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  with_options presence: true do
    validates :quantity, numericality: { greater_than: 0 }
    validates :total_price
  end
end
