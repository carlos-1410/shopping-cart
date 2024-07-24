# frozen_string_literal: true

require "test_helper"

class PricingRuleTest < ActiveSupport::TestCase
  test "required fields" do
    pricing_rule = build(:pricing_rule, :price_discount,
                         discount_type: nil, status: nil, min_amount: nil, discount_amount: nil)

    assert pricing_rule.invalid?

    %i(discount_type discount_amount status min_amount).each do |field|
      assert pricing_rule.errors.added?(field, :blank)
    end
  end

  test "invalid when status is not valid" do
    invalid_status = "invalid"
    pricing_rule = build(:pricing_rule, :price_discount, status: invalid_status)

    assert pricing_rule.invalid?
    assert pricing_rule.errors.added?(:status, :inclusion, value: invalid_status)
  end

  test "invalid when discount_type is not valid" do
    invalid_discount_type = "invalid"
    pricing_rule = build(:pricing_rule, :price_discount, discount_type: invalid_discount_type)

    assert pricing_rule.invalid?
    assert pricing_rule.errors.added?(:discount_type, :inclusion, value: invalid_discount_type)
  end

  test "invalid without a product" do
    pricing_rule = build(:pricing_rule, :buy_one_get_one_free_discount, product: nil)

    assert pricing_rule.invalid?
    assert pricing_rule.errors.added?(:product, :blank)
  end

  test "amounts are not required if buy_one_get_one_free?" do
    pricing_rule = build(:pricing_rule, :buy_one_get_one_free_discount,
                         min_amount: nil, discount_amount: nil)

    assert pricing_rule.buy_one_get_one_free?
    assert pricing_rule.valid?
  end

  test "only 1 active pricing rule allowed" do
    product = create(:product)
    create(:pricing_rule, :price_discount, product:)
    product.reload
    second_pricing_rule = build(:pricing_rule, :price_discount, product:)

    assert second_pricing_rule.invalid?
    assert second_pricing_rule.errors.added?(:status,
                                             "Only 1 active pricing rule per product allowed")
  end

  test "only 1 buy_one_get_one_free allowed" do
    product = create(:product)
    create(:pricing_rule, :buy_one_get_one_free_discount, product:)
    invalid_pricing_rule = build(:pricing_rule, :buy_one_get_one_free_discount, product:)
    assert invalid_pricing_rule.invalid?
    assert invalid_pricing_rule.errors.added?(:discount_type, :taken, value: "buy_one_get_one_free")
  end

  test "valid pricing rules" do
    %i(buy_one_get_one_free_discount price_discount percentage_discount).each do |discount_type|
      rule = build(:pricing_rule, discount_type)

      assert rule.valid?
    end
  end
end
