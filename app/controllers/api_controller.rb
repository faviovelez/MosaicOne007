class ApiController < ApplicationController

  def get_all_products
    products =  Product.where(classification: 'de línea').where(current: true, shared: true).where(child: nil).has_inventory(
      params[:q]
    ).collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')} #{p.exterior_color_or_design}", p.id ]
    end
    render json: { products: products }
  end

  def get_all_products_for_bill
    products =  Product.where(classification: 'de línea').where(current: true, shared: true).where(child: nil)
    store_products = Product.where(store: current_user.store)
    services = Service.where(current: true)
    options = []
    products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
      options << { "value" => string, "data" => product.id }
    end
    store_products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
      options << { "value" => string, "data" => product.id }
    end
    services.each do |service|
      words = service.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = service.unique_code + ' ' + words_clean
      options << { "value" => string, "data" => service.unique_code }
    end
    render json: { suggestions: options }
  end

  def get_just_products
    products =  Product.where(classification: 'de línea').where(current: true, shared: true)
    store_products = Product.where(store: current_user.store)
    options = []
    products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
      options << { "value" => string, "data" => product.id }
    end
    store_products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s
      options << { "value" => string, "data" => product.id }
    end
    render json: { suggestions: options }
  end

  def get_info_from_product
    product_info = []
    p = Product.find(params[:id])
    if current_user.store.store_type.store_type == 'franquicia'
      price_with_discount = (p.price * (1 - (p.discount_for_franchises / 100))).round(2)
      discount = p.discount_for_franchises
    elsif current_user.store.store_type.store_type == 'tienda propia'
      price_with_discount = (p.price * (1 - (p.discount_for_stores / 100))).round(2)
      discount = p.discount_for_stores
    else
      discount = 0
      price_with_discount = p.price.round(2)
    end
    images = []
    unless p.images == []
      p.images.each do |img|
        images << img.image_url
      end
    end
    separated = 0
    pending_orders = 0
    ProductRequest.where(product: p).where.not(status: "entregado").each do |request|
      if request.status == "asignado"
        separated += request.quantity.to_i
      elsif request.status == "sin asignar"
        pending_orders += request.quantity.to_i
      end
    end
    kg_available = []
    WarehouseEntry.where(product: p).order(:id).each do |we|
      kg_available << {we.movement.identifier => we.movement.kg}
    end
    kg_available << {"avg" => (p.average || 100)}
    product_info << [
      { description: "#{p.unique_code} #{p.description}" },
      { price: price_with_discount },
      { color: p.exterior_color_or_design },
      { inventory: p.quantity.to_i },
      { packages: p.pieces_per_package },
      { images: images },
      { discount: discount },
      { separated: separated},
      { total_inventory: separated + p.quantity},
      { kg: p.group },
      { availability: kg_available },
      { pending: pending_orders}
  ]
  render json: {response: product_info}
  end

  def get_all_suppliers_for_corporate(bu = current_user.store.business_unit.business_group)
    suppliers_group = []
    suppliers = Supplier.where(business_group: bu)
    suppliers.each do |sup|
      suppliers_group << {"value" => sup.name, "data" => sup.id }
    end
    render json: { suggestions: suppliers_group }
  end

  def get_prospects_for_store
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      prospects = current_user.store.prospects
    else
      prospects = Prospect.includes(:billing_address, :business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
    options = []
    prospects.each do |prospect|
      unless prospect.billing_address.nil?
        name = prospect.billing_address.business_name
        options << { "value" => name, "data" => prospect.id }
      end
    end
    render json: { suggestions: options }
  end

  def get_prospect_rfcs
    @prospects_rfcs = [['seleccione']]
    if (@user.role.name == 'store' || @user.role.name == 'store-admin')
      prospects = @store.prospects
    else
      prospects = Prospect.joins(:billing_address).joins(:business_unit).where(business_units: {name: 'Comercializadora de Cartón y Diseño'})
    end
  end

  def select_prospects_info
    prospect = Prospect.find(params[:prospect_id]).billing_address.rfc
    if prospect.present?
      render json: {
                    prospect: prospect
                   }
    else
      render json: {prospect: false}
    end
  end



end
