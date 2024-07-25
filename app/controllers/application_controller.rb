# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :initialize_cart

  private

  def initialize_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    return if @cart.present?

    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
