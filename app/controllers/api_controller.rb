class ApiController < ApplicationController

  def get_all_products
    products =  Product.where(classification: 'de línea').where(current: true, shared: true, child: nil).has_inventory(
      params[:q]
    ).collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')} #{p.exterior_color_or_design} #{p.only_measure.to_s}", p.id ]
    end
    render json: { products: products }
  end

  def get_all_products_for_bill
#    products =  Product.where(classification: 'de línea').where(current: true, shared: true, child: nil)
#    store_products = Product.where(store: current_user.store)
    services = Service.where(current: true)
    options = []
#    products.each do |product|
#      words = product.description.split(' ') [0..5]
#      words_clean = words.join(' ')
#      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s + ' ' + product.only_measure.to_s
#      options << { "value" => string, "data" => product.id }
#    end
#    store_products.each do |product|
#      words = product.description.split(' ') [0..5]
#      words_clean = words.join(' ')
#      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s + ' ' + product.only_measure.to_s
#      options << { "value" => string, "data" => product.id }
#    end
    services.each do |service|
      words = service.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = service.unique_code + ' ' + words_clean
      options << { "value" => string, "data" => service.unique_code }
    end
    render json: { suggestions: options }
  end

  def get_just_products
    if (current_user.role.name == 'warehouse-staff' || current_user.role.name == 'warehouse-admin')
      products =  Product.where(classification: 'de línea').where(current: true, shared: true)
    else
      products =  Product.where(classification: 'de línea').where(current: true, shared: true)
    end
    if (current_user.role.name == 'admin-desk' || current_user.role.name == 'warehouse-staff' || current_user.role.name == 'warehouse-admin' || current_user.role.name == 'product-admin' || current_user.role.name == 'product-staff')
      special_products = Product.where(classification: 'especial').where(business_unit_id: current_user.store.business_unit.id)
      products = products + special_products
    end
    store_products = Product.where(store: current_user.store)
    options = []
    products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s + ' ' + product.only_measure.to_s
      options << { "value" => string, "data" => product.id }
    end
    store_products.each do |product|
      words = product.description.split(' ') [0..5]
      words_clean = words.join(' ')
      string = product.unique_code + ' ' + words_clean  + ' ' + product.exterior_color_or_design.to_s + ' ' + product.only_measure.to_s
      options << { "value" => string, "data" => product.id } unless options.include?({ "value" => string, "data" => product.id }) || product.classification == 'especial'
    end
    render json: { suggestions: options }
  end

  def get_info_from_product_with_prospect
    product_info = []
    p = Product.find(params[:id])
    wholesale_discount(p)
    if current_user.store.store_type.store_type == 'franquicia'
      price_with_discount = (p.price * (1 - (p.discount_for_franchises.to_f / 100))).round(2)
      discount = p.discount_for_franchises.to_f
      prospect_discount = current_user.store.store_prospect.discount.to_f
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'tienda propia'
      price_with_discount = (p.price * (1 - (p.discount_for_stores.to_f / 100))).round(2)
      discount = p.discount_for_stores.to_f
      prospect_discount = current_user.store.store_prospect.discount.to_f
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'corporativo'
      prospect = Prospect.find(params[:prospect_id])
      prospect_discount = prospect.discount.to_f
      discount = 0
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    else
      discount = 0
      price_with_discount = p.price.round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    end
    images = []
    unless p.images == []
      p.images.each do |img|
        images << img.image_url
      end
    end
    separated = 0
    pending_orders = 0
    product_requests = ProductRequest.joins(:order).where(product: p, corporate_id: p.business_unit.stores.where(store_type_id: 2).first).where.not(status: ['entregado', 'cancelada']).where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] })
    product_requests.each do |request|
      if request.status == "asignado"
        separated += request.quantity.to_i
      elsif request.status == "sin asignar"
        pending_orders += request.quantity.to_i
      end
    end
    kg_available = []
    WarehouseEntry.where(product: p, store_id: p.business_unit.stores.where(store_type_id: 2).first).order(:id).each do |we|
      kg_available << {we.movement.identifier => we.movement.kg} if p.group && we.movement != nil
    end
    kg_available << {"avg" => (p.average || 100)}
    if p.business_unit.stores.where(store_type_id: 2).first.id.to_i == 1
      quantity = Inventory.where(product: p).first.quantity.to_i
    else
      quantity = StoresInventory.where(product: p, store_id: p.business_unit.stores.where(store_type_id: 2).first).first.quantity.to_i
    end
    product_info << [
      { description: "#{p.unique_code} #{p.description}" },
      { price: price_with_discount },
      { color: p.exterior_color_or_design },
      { inventory: quantity },
      { packages: p.pieces_per_package },
      { images: images },
      { discount: discount },
      { separated: separated},
      { total_inventory: separated + quantity},
      { kg: p.group },
      { availability: kg_available },
      { pending: pending_orders},
      { armed: p.armed},
      { armed_price: armed_price},
      { armed_discount: armed_discount},
      { wholesale_discount: @wholesale_discount },
      { wholesale_quantity: @wholesale_quantity },
      { price_without_discount: p.price },
      { prospect_discount: prospect_discount }
    ]
    render json: {response: product_info}
  end

  def get_info_from_product_store
    product_info = []
    p = Product.find(params[:id])
    wholesale_discount(p)
    if current_user.store.store_type.store_type == 'franquicia'
      discount = Store.find(params[:this_store]).store_prospect.discount.to_f
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      prospect_discount = current_user.store.store_prospect.discount.to_f
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'tienda propia'
      discount = Store.find(params[:this_store]).store_prospect.discount.to_f
      prospect_discount = Store.find(params[:this_store]).store_prospect.discount.to_f
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'corporativo'
      if params[:prospect_id] == nil
        prospect = Prospect.find(Store.find(1).store_prospect)
      end
      discount = prospect.discount.to_f
      prospect_discount = discount
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    else
      discount = 0
      price_with_discount = p.price.round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    end
    images = []
    unless p.images == []
      p.images.each do |img|
        images << img.image_url
      end
    end
    separated = 0
    pending_orders = 0
    product_requests = ProductRequest.joins(:order).where(product: p, corporate_id: params[:store_id].to_i).where.not(status: ['entregado', 'cancelada']).where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] })
    product_requests.each do |request|
      if request.status == "asignado"
        separated += request.quantity.to_i
      elsif request.status == "sin asignar"
        pending_orders += request.quantity.to_i
      end
    end
    kg_available = []
    WarehouseEntry.where(product: p, store_id: p.business_unit.stores.where(store_type_id: 2).first).order(:id).each do |we|
      kg_available << {we.movement.identifier => we.movement.kg} if p.group && we.movement != nil
    end
    kg_available << {"avg" => (p.average || 100)}
    if p.business_unit.stores.where(store_type_id: 2).first.id.to_i == 1
      quantity = Inventory.where(product: p).first.quantity.to_i
    else
      quantity = StoresInventory.where(product: p, store_id: p.business_unit.stores.where(store_type_id: 2).first).first.quantity.to_i
    end
    product_info << [
      { description: "#{p.unique_code} #{p.description}" },
      { price: price_with_discount },
      { color: p.exterior_color_or_design },
      { inventory: quantity },
      { packages: p.pieces_per_package },
      { images: images },
      { discount: discount },
      { separated: separated},
      { total_inventory: separated + quantity},
      { kg: p.group },
      { availability: kg_available },
      { pending: pending_orders},
      { armed: p.armed},
      { armed_price: armed_price},
      { armed_discount: armed_discount},
      { wholesale_discount: @wholesale_discount },
      { wholesale_quantity: @wholesale_quantity },
      { price_without_discount: p.price },
      { prospect_discount: prospect_discount }
    ]
    render json: {response: product_info}
  end

  def wholesale_discount(product)
    if current_user.store.store_type.store_type == 'franquicia'
      @wholesale_discount = product.franchises_discount.to_f
    elsif current_user.store.store_type.store_type == 'tienda propia' || current_user.store.store_type.store_type == 'corporativo'
      @wholesale_discount = product.stores_discount.to_f
    else
      @wholesale_discount = 0
    end
    @wholesale_quantity = product.factor
  end

  def get_info_from_product
    product_info = []
    p = Product.find(params[:id])
    wholesale_discount(p)
    if current_user.store.store_type.store_type == 'franquicia'
      discount = Store.find(params[:this_store]).store_prospect.discount.to_f
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      prospect_discount = discount
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount / 100))).round(2)
        armed_discount = p.armed_discount
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'tienda propia'
      discount = Store.find(params[:this_store]).store_prospect.discount.to_f
      prospect_discount = discount
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    elsif current_user.store.store_type.store_type == 'corporativo'
      if params[:prospect_id] == nil
        prospect = Prospect.find(Store.find(1).store_prospect)
      end
      discount = prospect.discount.to_f
      price_with_discount = (p.price * (1 - (discount / 100))).round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    else
      discount = 0
      price_with_discount = p.price.round(2)
      if p.armed
        armed_price = (p.price * (1 - (p.armed_discount.to_f / 100))).round(2)
        armed_discount = p.armed_discount.to_f
      else
        armed_price = price_with_discount
        armed_discount = discount
      end
    end
    images = []
    unless p.images == []
      p.images.each do |img|
        images << img.image_url
      end
    end
    separated = 0
    pending_orders = 0
    product_requests = ProductRequest.joins(:order).where(product: p, corporate_id: params[:store_id].to_i).where.not(status: ['entregado', 'cancelada']).where.not(orders: {status: ['en ruta', 'entregado', 'cancelado'] })
    product_requests.each do |request|
      if request.status == "asignado"
        separated += request.quantity.to_i
      elsif request.status == "sin asignar"
        pending_orders += request.quantity.to_i
      end
    end
    kg_available = []
    WarehouseEntry.where(product: p, store_id: params[:store_id].to_i).order(:id).each do |we|
      kg_available << {we.movement.identifier => we.movement.kg} if p.group && we.movement != nil
    end
    kg_available << {"avg" => (p.average || 100)}
    if params[:store_id].to_i == 1
      quantity = Inventory.where(product: p).first.quantity.to_i
    else
      quantity = StoresInventory.where(product: p, store_id: params[:store_id].to_i).first.quantity.to_i
    end
    product_info << [
      { description: "#{p.unique_code} #{p.description}" },
      { price: price_with_discount },
      { color: p.exterior_color_or_design },
      { inventory: quantity },
      { packages: p.pieces_per_package },
      { images: images },
      { discount: discount },
      { separated: separated},
      { total_inventory: separated + quantity},
      { kg: p.group },
      { availability: kg_available },
      { pending: pending_orders},
      { armed: p.armed},
      { armed_price: armed_price},
      { armed_discount: armed_discount},
      { wholesale_discount: @wholesale_discount },
      { wholesale_quantity: @wholesale_quantity },
      { price_without_discount: p.price },
      { prospect_discount: prospect_discount }
    ]
    render json: {response: product_info}
  end

  def get_all_suppliers_for_corporate(bu = current_user.store.business_unit.business_group)
    suppliers_group = []
    suppliers = Supplier.where(store_id: current_user.store.id)
    suppliers.each do |sup|
      suppliers_group << {"value" => sup.id.to_s + ' ' + sup.name, "data" => sup.id, "days" => sup.credit_days }
    end
    render json: { suggestions: suppliers_group }
  end

  def get_prospects_for_store(role = current_user.role.name)
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      prospects = current_user.store.prospects
    else
      prospects = Prospect.where(store_id: current_user.store.id)
    end
    corporate = Store.joins(:store_type).where(store_types: {store_type: 'corporativo'}).pluck(:id)
    Store.all.each do |store|
      unless prospects.include?(store.store_prospect)
        prospects << store.store_prospect if corporate.include?(current_user.store.id)
      end
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
