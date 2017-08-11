class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    role = Role.find_by_name('store') || Role.find_by_name('store-admin')
    @order = Order.new(user: current_user, store: current_user.store, category: 'de línea')
    redirect_to root_path, alert: 'No cuenta con los permisos necesarios' unless current_user.role == role
  end

  def get_product
    product = Product.find(params[:product])
    if product.present?
      render json: {
                    product: product,
                    images: product.images,
                    inventory: product.valid_inventory,
                   }
    else
      render json: {product: false}
    end
  end

  def save_products
    binding.pry
  end

  def catalog
  end

  def special
  end

  def index
  end
end
