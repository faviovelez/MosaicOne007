class ProductsBill < ActiveRecord::Base
  # Tabla intermedia que conecta varios products con varias bills (un producto puede tener muchas bills, una bill puede tener muchos productos)
  belongs_to :product
  belongs_to :bill
end
