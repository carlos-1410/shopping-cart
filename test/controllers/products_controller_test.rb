# frozen_string_literal: true

require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test "index" do
    product = create(:product)

    get products_path
    assert_response :success
    assert_includes response.body, "<div class=\"col-1\">\n    #{product.code}\n  </div>\n  " \
                                   "<div class=\"col-2\">\n    #{product.name}\n  </div>\n  " \
                                   "<div class=\"col-1\">\n    €#{cents_to_amount(product.price)}"
  end

  test "new" do
    get new_product_path
    assert_response :success
  end

  test "edit" do
    product = create(:product)

    get edit_product_path(product)
    assert_response :success
    assert_includes response.body, "<input class=\"form-control\" type=\"text\" " \
                                   "value=\"#{product.price}\" " \
                                   "name=\"product[price]\" id=\"product_price\" />"
    assert_includes response.body, "<h1>Edit product: #{product.name}</h1>"
  end

  test "create" do
    product = build(:product).attributes

    assert_difference -> { Product.count }, +1 do
      post products_path, params: { product: }
    end

    assert_redirected_to edit_product_path(Product.last.id)
  end

  test "create fails" do
    product = build(:product).attributes.merge(code: nil)

    assert_no_difference -> { Product.count } do
      post products_path, params: { product: }
      assert_response :unprocessable_entity
      assert_template :new
    end
  end

  test "update" do
    product = create(:product)
    new_code = "PR-123"

    put product_path(product), params: { product: { code: new_code } }

    product.reload
    assert product.code, new_code
    assert_redirected_to edit_product_path(product)
  end

  test "update fails" do
    product = create(:product)

    put product_path(product), params: { product: { code: nil } }

    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "destroy" do
    product = create(:product)

    assert_difference -> { Product.count }, -1 do
      delete product_path(product)
    end

    assert_redirected_to products_path
  end
end
