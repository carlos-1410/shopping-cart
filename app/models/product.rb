# frozen_string_literal: true

class Product < ApplicationRecord
  with_options presence: true do
    validates :code, :name, :price
    validates :price, numericality: { greater_than: 0 }
  end
end
