# frozen_string_literal: true

module ShoppingCart
  class ItemManager
    def initialize(cart:, product:, quantity: 0, remove: false)
      @cart = cart
      @product = product
      @quantity = quantity
      @remove = remove
    end

    def call
      return destroy_cart_item if remove

      if item_in_cart?
        update_cart_item
      else
        return Response.failure("Invalid quantity") if quantity <= 0

        create_cart_item
      end
    end

    private

    attr_reader :cart, :product, :quantity, :remove

    def create_cart_item
      new_cart_item = cart.cart_items.create(product:, quantity:, total_price:)

      if new_cart_item.persisted?
        Response.success(new_cart_item)
      else
        Response.failure(new_cart_item.errors.full_messages.to_sentence)
      end
    end

    def update_cart_item
      if quantity.positive?
        cart_item.save_with_response(quantity:, total_price:)
      else
        destroy_cart_item
      end
    end

    def destroy_cart_item
      cart_item.destroy_with_response
    end

    def item_in_cart?
      cart_item.present?
    end

    def cart_item
      cart.cart_items.find_by(product_id: product.id)
    end

    def total_price
      # Discount has to be calculated here
      product.price * quantity
    end
  end
end
