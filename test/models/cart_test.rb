# frozen_string_literal: true

require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "destroy all the related cart_items" do
    cart = Cart.create
    2.times { create(:cart_item, cart:) }

    assert_difference -> { CartItem.count }, -2 do
      cart.destroy
    end
  end
end
