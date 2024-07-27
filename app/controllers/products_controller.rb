# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def edit
    product
  end

  def create
    @product = Product.find_or_initialize_by(product_attributes)

    respond_to do |format|
      if @product.save
        format.html { redirect_to edit_product_path(@product) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if product.update(product_attributes)
        format.html do
          redirect_to edit_product_path(product),
                      flash: { notice: "Product was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if product.destroy
        format.html do
          redirect_to products_path,
                      flash: { notice: "Product was successfully removed." }
        end
      end
    end
  end

  private

  def product
    @product ||= Product.find(params[:id])
  end

  def product_attributes
    params.require(:product).permit(:name, :code, :price)
  end
end
