module WarehouseHelper

  def products_collection
    Product.all.collect do |p|
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
      :image_url) || 'product_small.png'
  end
end
