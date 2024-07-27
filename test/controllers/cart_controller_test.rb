# frozen_string_literal: true

require "test_helper"

class CartControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
  end

  test "#add throws an error quantity is zero" do
    assert_difference -> { Cart.count }, +1 do
      assert_no_difference -> { CartItem.count } do
        post add_to_cart_path, params: { product_id: @product.id, quantity: 0 }

        assert_equal flash[:error], "Invalid quantity"
        assert_redirected_to products_path
      end
    end
  end

  test "#add adds new product to cart" do
    assert_cart_item_added(@product.id, 1)
  end

  test "#add changes quantity of the product in cart with positive quantity param" do
    assert_cart_item_added(@product.id, 1)

    assert_no_difference -> { CartItem.count } do
      post add_to_cart_path, params: { product_id: @product.id, quantity: 2 }

      cart_item = CartItem.find_by(product_id: @product.id)
      assert_equal 3, cart_item.quantity
    end
  end

  test "#add removes the product if the quantity param is lower than current product quantity" do
    assert_cart_item_added(@product.id, 1)

    assert_difference -> { CartItem.count }, -1 do
      post add_to_cart_path, params: { product_id: @product.id, quantity: -2 }

      cart_item = CartItem.find_by(product_id: @product.id)
      assert_nil cart_item
    end
  end

  test "#add redirects to cart if change was made in cart" do
    assert_difference -> { Cart.count }, +1 do
      assert_difference -> { CartItem.count }, +1 do
        post add_to_cart_path, params: { product_id: @product.id, quantity: 1, cart: true }
        assert_redirected_to cart_path
      end
    end
  end

  test "#remove destroys cart_item" do
    assert_cart_item_added(@product.id, 1)

    assert_difference -> { CartItem.count }, -1 do
      post remove_from_cart_path, params: { product_id: @product.id }
      assert_redirected_to cart_path
    end
  end

  private

  def assert_cart_item_added(product_id, quantity)
    assert_difference -> { Cart.count }, +1 do
      assert_difference -> { CartItem.count }, +1 do
        post add_to_cart_path, params: { product_id:, quantity: }
        assert_redirected_to products_path
      end
    end
  end
end
