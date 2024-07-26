# frozen_string_literal: true

require "test_helper"

module DiscountCalculator
  class ManagerTest < ActiveSupport::TestCase
    setup do
      @product = create(:product)
    end

    test "returns product price when discount_rule is inactive" do
      discount_rule = create(:discount_rule, :price_discount, product: @product,
                             status: DiscountRule::INACTIVE_STATUS)
      args = { product: @product, quantity: 1, discount_rule: discount_rule }
      result = Manager.new(**args).call

      assert_equal result, @product.price
    end

    test "buy_one_get_one_free discount" do
      prepare_expectations_for(BuyOneGetOneFreeStrategy, :buy_one_get_one_free_discount)
    end

    test "percentage discount" do
      prepare_expectations_for(PercentageStrategy, :percentage_discount)
    end

    test "price discount" do
      prepare_expectations_for(PriceStrategy, :price_discount)
    end

    private

    def prepare_expectations_for(klass, discount_type, status: DiscountRule::ACTIVE_STATUS)
      discount_rule = create(:discount_rule, discount_type, product: @product, status:)
      args = { product: @product, quantity: 1, discount_rule: discount_rule }

      discount_calculator_mock = mock
      discount_calculator_mock.expects(:call)

      klass.expects(:new).with(**args).returns(discount_calculator_mock)

      Manager.new(**args).call
    end
  end
end
