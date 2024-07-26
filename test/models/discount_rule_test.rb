# frozen_string_literal: true

require "test_helper"

class PricingRuleTest < ActiveSupport::TestCase
  test "required fields" do
    discount_rule = build(:discount_rule, :price_discount,
                         discount_type: nil, status: nil,
                         min_quantity: nil, amount: nil, product: nil)

    assert discount_rule.invalid?

    %i(discount_type amount status min_quantity product).each do |field|
      assert discount_rule.errors.added?(field, :blank)
    end
  end

  test "invalid when status is not valid" do
    invalid_status = "invalid"
    discount_rule = build(:discount_rule, :price_discount, status: invalid_status)

    assert discount_rule.invalid?
    assert discount_rule.errors.added?(:status, :inclusion, value: invalid_status)
  end

  test "invalid when discount_type is not valid" do
    invalid_discount_type = "invalid"
    discount_rule = build(:discount_rule, :price_discount, discount_type: invalid_discount_type)

    assert discount_rule.invalid?
    assert discount_rule.errors.added?(:discount_type, :inclusion, value: invalid_discount_type)
  end

  test "invalid without a product" do
    discount_rule = build(:discount_rule, :buy_one_get_one_free_discount, product: nil)

    assert discount_rule.invalid?
    assert discount_rule.errors.added?(:product, :blank)
  end

  test "amounts are not required if buy_one_get_one_free?" do
    discount_rule = build(:discount_rule, :buy_one_get_one_free_discount,
                         min_quantity: nil, amount: nil)

    assert discount_rule.buy_one_get_one_free?
    assert discount_rule.valid?
  end

  test "non-numeric amounts are invalid" do
    invalid_amount = "invalid"
    discount_rule = build(:discount_rule, :price_discount,
                         min_quantity: invalid_amount, amount: invalid_amount)

    assert discount_rule.invalid?
    assert discount_rule.errors.added?(:min_quantity, :not_a_number, greater_than_or_equal: 0,
                                                                  value: invalid_amount)
    assert discount_rule.errors.added?(:amount, :not_a_number, value: invalid_amount)
  end

  test "only 1 buy_one_get_one_free allowed" do
    product = create(:product)
    create(:discount_rule, :buy_one_get_one_free_discount, product:)
    invalid_discount_rule = build(:discount_rule, :buy_one_get_one_free_discount, product:)
    assert invalid_discount_rule.invalid?
    assert invalid_discount_rule.errors.added?(:discount_type, :taken, value: "buy_one_get_one_free")
  end

  test "valid pricing rules" do
    %i(buy_one_get_one_free_discount price_discount percentage_discount).each do |discount_type|
      rule = build(:discount_rule, discount_type)

      assert rule.valid?
    end
  end
end
