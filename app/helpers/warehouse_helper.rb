module WarehouseHelper

  def movements_path
    '#'
  end

  def products_collection
    Product.all.collect do |p|
      words = p.description.split(' ') [0..5]
      ["#{p.unique_code} #{words.join(' ')}", p.id ]
    end
  end
end
