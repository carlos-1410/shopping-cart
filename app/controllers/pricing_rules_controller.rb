# frozen_string_literal: true

class PricingRulesController < ApplicationController
  def new
    @pricing_rule = PricingRule.new
  end

  def edit
    pricing_rule
  end

  def create # rubocop:disable Metrics/AbcSize
    @pricing_rule = PricingRule.find_or_initialize_by(pricing_rule_attributes.except(:status))
    @pricing_rule.status = pricing_rule_attributes.fetch(:status) unless @pricing_rule.persisted?

    respond_to do |format|
      if @pricing_rule.save
        format.html { redirect_to edit_product_path(@pricing_rule.product) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if pricing_rule.update(pricing_rule_attributes)
        format.html do
          redirect_to edit_product_path(pricing_rule.product),
                      notice: "Pricing rule was successfully updated."
        end
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    product = pricing_rule.product
    respond_to do |format|
      if pricing_rule.destroy
        format.html do
          redirect_to edit_product_path(product),
                      notice: "Pricing rule was successfully destroyed."
        end
      end
    end
  end

  private

  def pricing_rule
    @pricing_rule ||= PricingRule.find(params[:id])
  end

  def pricing_rule_attributes
    params.require(:pricing_rule).permit(:discount_type, :discount_amount,
                                         :status, :min_quantity, :product_id)
  end
end
