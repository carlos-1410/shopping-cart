# frozen_string_literal: true

class CartController < ApplicationController
  def show; end

  def add
    response = ShoppingCart::ItemManager.new(cart: @cart, product: product,
                                             quantity: quantity).call
    redirect_path = params[:cart].present? ? cart_path : products_path

    respond_to do |format|
      if response.success?
        format.html { redirect_to redirect_path, flash: { notice: "Your cart has been updated." } }
      else
        format.html { redirect_to redirect_path, flash: { error: response.value } }
      end
    end
  end

  def remove
    response = ShoppingCart::ItemManager.new(cart: @cart, product: product,
                                             remove: true).call

    respond_to do |format|
      if response.success?
        format.html do
          redirect_to cart_path, flash: { notice: "Product has been removed from your cart." }
        end
      else
        format.html { render :show, flash: { error: response.value } }
      end
    end
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def quantity
    params[:quantity].to_i
  end
end
