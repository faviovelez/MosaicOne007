module WarehouseHelper

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

  def image(movement)
    movement.product.images.first.try(
      :image_url, :thumb) || 'product_thumb.png'
  end

  def warehouse_name(order)
    user = order.users.joins(:role).where('roles.name' => ['warehouse-staff', 'warehouse-admin']).first
    if user == nil
      name = 'sin asignar'
    else
      name = user.first_name + " " + user.last_name
    end
    name
  end

end
