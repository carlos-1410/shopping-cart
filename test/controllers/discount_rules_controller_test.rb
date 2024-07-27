# frozen_string_literal: true

require "test_helper"

class DiscountRulesControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    product = create(:product)
    get new_discount_rule_path(product_id: product.id)
    assert_response :success
  end

  test "edit" do
    discount_rule = create(:discount_rule, :price_discount)

    get edit_discount_rule_path(discount_rule)
    assert_response :success
    assert_includes response.body, "<input value=\"#{discount_rule.product.id}\" " \
                                   "autocomplete=\"off\" type=\"hidden\" " \
                                   "name=\"discount_rule[product_id]\" " \
                                   "id=\"discount_rule_product_id\" />"
    assert_includes response.body, "<h1>Edit discount rule: #{discount_rule.discount_type}</h1>"
    assert_includes response.body, "<input class=\"form-control\" type=\"text\" " \
                                   "value=\"#{discount_rule.min_quantity}\" " \
                                   "name=\"discount_rule[min_quantity]\" " \
                                   "id=\"discount_rule_min_quantity\" />"
  end

  test "create" do
    product = create(:product)
    discount_rule = build(:discount_rule, :percentage_discount, product:).attributes

    assert_difference -> { product.discount_rules.count }, +1 do
      post discount_rules_path, params: { discount_rule: }
    end

    assert_redirected_to edit_product_path(product.id)
  end

  test "create without duplicates" do
    product = create(:product)
    discount_rule = build(:discount_rule, :percentage_discount, product:).attributes

    assert_difference -> { product.discount_rules.count }, +1 do
      2.times do
        post discount_rules_path, params: { discount_rule: }
      end
    end

    assert_redirected_to edit_product_path(product.id)
  end

  test "create fails" do
    product = create(:product)
    discount_rule = { min_quantity: nil, amount: nil, status: "invalid",
                      discount_type: "invalid", product_id: product.id, }

    assert_no_difference -> { product.discount_rules.count } do
      post discount_rules_path, params: { discount_rule: }
      assert_response :unprocessable_entity
      assert_template :new
    end
  end

  test "update" do
    product = create(:product)
    discount_rule = create(:discount_rule, :percentage_discount, product:)
    new_min_quantity = 5

    put discount_rule_path(discount_rule),
        params: { discount_rule: { min_quantity: new_min_quantity } }

    discount_rule.reload
    assert discount_rule.min_quantity, new_min_quantity
    assert_redirected_to edit_product_path(product)
  end

  test "update fails" do
    product = create(:product)
    discount_rule = create(:discount_rule, :percentage_discount, product:)

    put discount_rule_path(discount_rule), params: { discount_rule: { min_quantity: nil } }

    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "destroy" do
    product = create(:product)
    discount_rule = create(:discount_rule, :percentage_discount, product:)

    assert_difference -> { product.discount_rules.count }, -1 do
      delete discount_rule_path(discount_rule)
    end

    assert_redirected_to edit_product_path(product)
  end
end
