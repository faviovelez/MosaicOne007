class InventoriesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    filter_products
  end

  def products
    filter_products
  end

  def filter_products
    @products = []
    user = current_user.role.name
    suppliers_id = []
    store = current_user.store
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    @products = Product.where(supplier: suppliers_id)
    @products
  end

  def order_suggestions
    filter_products
  end

  def former_filter
    @products = []
    user = current_user.role.name
    suppliers_id = []
    store = current_user.store
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    @dc_products = Product.where(supplier: suppliers_id)
    if (user == 'store-admin' || user == 'store')
      @products = @dc_products
      store.products each do |product|
        @products << product unless @products.include?(product)
      end
    else
      @products = @dc_products
    end
    @products
  end

end
