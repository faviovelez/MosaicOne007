module DiscountRulesHelper

  def stores
    @stores = []
    b_units = current_user.store.business_group.business_units
    b_units.each do |bu|
      bu.stores.each do |s|
        @stores << [s.store_name, s.id]
      end
    end
    @stores
  end

  def business_units
    @business_units = []
    b_units = current_user.store.business_group.business_units
    b_units.each do |bu|
      @business_units << [bu.name, bu.id]
    end
    @business_units
  end

  def prospect_filter
    if current_user.role.name == 'admin-desk'
      @prospect_group = [
              ['todos los clientes'],
              ['clientes finales (no tiendas)'],
              ['tiendas propias y franquicias'],
              ['solo tiendas propias'],
              ['solo franquicias'],
              ['solo distribuidores'],
              ['solo corporativo'],
              ['seleccionar de la lista']
            ]
    else
      @prospect_group = [['todos los clientes'],['seleccionar de la lista']]
    end
    @prospect_group
  end

  def select_prospects
    @all_prospects = []
    if current_user.role.name == 'admin-desk'
      bg_p = current_user.store.business_unit.business_group.prospects
      bg_p.each do |prospect|
        @all_prospects << [prospect.legal_or_business_name, prospect.id]
      end
    else
      store_p = current_user.store.prospects
      store_p.each do |prospect|
        @all_prospects << [prospect.legal_or_business_name, prospect.id]
      end
    end
    @all_prospects
  end

  def product_filter
      @product_group = [
              ['todos los productos de línea'],
              ['seleccionar líneas de producto'],
              ['seleccionar productos por material'],
              ['seleccionar de la lista']
            ]
    @product_group
  end

  def select_products
    @all_products = []
    suppliers_id = []
    store = current_user.store
    Supplier.where(name: [
                          'Diseños de Cartón',
                          'Comercializadora de Cartón y Diseño'
                          ]).each do |supplier|
                            suppliers_id << supplier.id
                          end
    dc_products = Product.where(supplier: suppliers_id).where.not(classification: ['especial', 'de tienda'])
    dc_products.each do |product|
      @all_products << [product.description, product.id]
    end
    if (current_user.role.name == 'store-admin' || current_user.role.name == 'store')
      b_u_products = Product.where(business_unit: business_units)
      b_u_products.each do |product|
        @all_products << [product.description, product.id]
      end
    end
    @all_products
  end

  def select_product_line
    @product_line_options = [['seleccione', '']]
    Classification.all.collect{ |p| [p.name, p.id] }.each do |o|
      @product_line_options << o
    end
    @product_line_options
  end

  def select_product_material
    @product_material_options = [['seleccione', '']]
    Material.all.collect{ |p| [p.name, p.id] }.each do |o|
      @product_material_options << o
    end
    @product_material_options
  end

end
