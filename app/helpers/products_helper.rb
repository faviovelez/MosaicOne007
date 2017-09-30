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

end
