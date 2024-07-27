# frozen_string_literal: true

class DiscountRulesController < ApplicationController
  def new
    @discount_rule = DiscountRule.new
  end

  def edit
    discount_rule
  end

  def create # rubocop:disable Metrics/AbcSize
    @discount_rule = DiscountRule.find_or_initialize_by(discount_rule_attributes.except(:status))
    @discount_rule.status = discount_rule_attributes.fetch(:status) unless @discount_rule.persisted?

    respond_to do |format|
      if @discount_rule.save
        format.html do
          redirect_to edit_product_path(@discount_rule.product),
                      flash: { notice: "Pricing rule was successfully created." }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if discount_rule.update(discount_rule_attributes)
        format.html do
          redirect_to edit_product_path(discount_rule.product),
                      flash: { notice: "Pricing rule was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    product = discount_rule.product
    respond_to do |format|
      if discount_rule.destroy
        format.html do
          redirect_to edit_product_path(product),
                      flash: { notice: "Pricing rule was successfully removed." }
        end
      end
    end
  end

  private

  def discount_rule
    @discount_rule ||= DiscountRule.find(params[:id])
  end

  def discount_rule_attributes
    params
      .require(:discount_rule)
      .permit(:discount_type, :amount, :status, :min_quantity, :product_id)
  end
end
