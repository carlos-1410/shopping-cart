# frozen_string_literal: true

require "test_helper"

class PricingRulesControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    product = create(:product)
    get new_pricing_rule_path(product_id: product.id)
    assert_response :success
  end

  test "edit" do
    pricing_rule = create(:pricing_rule, :price_discount)

    get edit_pricing_rule_path(pricing_rule)
    assert_response :success
    assert_includes response.body, "<input value=\"#{pricing_rule.product.id}\" autocomplete=\"off\" " \
                                   "type=\"hidden\" name=\"pricing_rule[product_id]\" " \
                                   "id=\"pricing_rule_product_id\" />"
    assert_includes response.body, "<h1>Edit pricing rule: #{pricing_rule.product.name}</h1>"
    assert_includes response.body, "<input type=\"text\" value=\"#{pricing_rule.min_amount}\" " \
                                   "name=\"pricing_rule[min_amount]\" id=\"pricing_rule_min_amount\" />"
  end

  test "create" do
    product = create(:product)
    pricing_rule = build(:pricing_rule, :percentage_discount, product:).attributes

    assert_difference -> { product.pricing_rules.count }, +1 do
      post pricing_rules_path, params: { pricing_rule: }
    end

    assert_redirected_to edit_product_path(product.id)
  end

  test "create without duplicates" do
    product = create(:product)
    pricing_rule = build(:pricing_rule, :percentage_discount, product:).attributes

    assert_difference -> { product.pricing_rules.count }, +1 do
      2.times do
        post pricing_rules_path, params: { pricing_rule: }
      end
    end

    assert_redirected_to edit_product_path(product.id)
  end

  test "update" do
    product = create(:product)
    pricing_rule = create(:pricing_rule, :percentage_discount, product:)
    new_min_amount = 5

    put pricing_rule_path(pricing_rule), params: { pricing_rule: { min_amount: new_min_amount } }

    pricing_rule.reload
    assert pricing_rule.min_amount, new_min_amount
    assert_redirected_to edit_product_path(product)
  end

  test "destroy" do
    product = create(:product)
    pricing_rule = create(:pricing_rule, :percentage_discount, product:)

    assert_difference -> { product.pricing_rules.count }, -1 do
      delete pricing_rule_path(pricing_rule)
    end

    assert_redirected_to edit_product_path(product)
  end
end
