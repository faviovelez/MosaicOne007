module WarehouseHelper

  def options_to_remove
    [
      "Uso tienda",
      "Crear producto",
      "Exhibición",
      "Promocional",
      "Producto dañado",
      "Ajuste (producto faltante)"
    ]
  end

  def products_collection
    Product.has_inventory.collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')} #{p.exterior_color_or_design}", p.id ]
    end
  end

  def suppliers_collection
    [['Selecione un proveedor', ' ']] + Supplier.all.collect do |s|
      [s.name,  s.id]
    end
  end

  def warehouse_user_name(order)
    user = order.users.joins(:role).where(roles: {name: ["warehouse-admin", "warehouse-staff"]}).first
    name = user.first_name.capitalize + " " + user.middle_name.to_s.capitalize + " " + user.last_name.capitalize
    name
  end

  def image(movement)
    movement.product.images.first.try(
      :image_url, :thumb) || 'product_thumb.png'
  end

  def warehouse_name(order)
    user = order.users.joins(:role).where('roles.name' => ['warehouse-staff', 'warehouse-admin']).first
    if user == nil
      name = content_tag(:span, 'sin asignar', class: 'label label-danger')
    else
      name = user.first_name.capitalize + " " + user.last_name.capitalize
    end
    name
  end

  def driver_name(order)
    delivery = order.delivery_attempt
    if delivery == nil
      name = content_tag(:span, 'sin asignar', class: 'label label-danger')
    else
      name = delivery.driver.first_name.capitalize + " " + user.last_name.capitalize
    end
    name
  end

# CONFIRMAR SI VOY A USAR ESTE MÉTODO (ES PARA USARLO EN LA PREPARACIÓN DE ALMACÉN PARA ACCEDER A AGREGAR PAQUETES AL DELIVERY)
  def find_user(order)
    @finded_user = nil
    users = order.users
    warehouse_users = User.joins(:role).where("roles.name = ? OR roles.name = ?", "warehouse-staff", "warehouse-admin")
    users.each do |user|
      store_users.each do |w_user|
        if user == w_user
          @finded_user = user
        end
      end
    end
    @finded_user
  end

  def actual_inventory(product)
    product.quantity
  end

end
