module ProductsHelper

  def suppliers
    @suppliers = []
    role = current_user.role.name
    b_u = current_user.store.business_unit
    main_bu = BusinessUnit.where(main: true)
    if (role == 'product-admin' || role == 'product-staff') || (role == 'store-admin' || role == 'store' && (main_bu.include?(b_u) == true ))
      suppliers = Supplier.where(name: [
                            'Diseños de Cartón',
                            'Comercializadora de Cartón y Diseño'
                            ])
      @suppliers = suppliers.collect{|s| [s.name, s.id]}
    else
      @suppliers = b_u.suppliers
    end
    @suppliers
  end

  def show_price_with_overprice(inventory)
    store = current_user.store
    if (current_user.role.name == 'store' || current_user.role.name == 'store-admin')
      manual_price = inventory.manual_price
      if (manual_price == nil || manual_price == 0)
        overp = ('%.2f' % (inventory.product.price * (1 + (inventory.store.overprice / 100)))).to_f
        @price = (overp * 1.16).round(2)
      else
        @price = manual_price * 1.16
      end
    else
      @price = inventory.product.price
    end
  end

  def convert_warehouses_to_options
    @warehouses_options = []
    @warehouses.each do |w|
      @warehouses_options << [w.name, w.id]
    end
    @warehouses_options
  end

  def get_sat_keys
    @sat_keys = []
    Product.find_each do |prod|
      @sat_keys << [prod.sat_key.sat_key, prod.sat_key.id] unless @sat_keys.include?([prod.sat_key.sat_key, prod.sat_key.id])
    end
    @sat_keys
  end

  def get_sat_unit_keys
    @sat_unit_keys = []
    Product.find_each do |prod|
      @sat_unit_keys << [prod.sat_unit_key.unit, prod.sat_unit_key.id] unless @sat_unit_keys.include?([prod.sat_unit_key.unit, prod.sat_unit_key.id])
    end
    @sat_unit_keys
  end

end
