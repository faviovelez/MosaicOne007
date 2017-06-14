class AddPriceFromProductCatalog < ActiveRecord::Migration
  def change
    add_column :product_catalogs, :price, :float
  end
end
