class RemoveCostFromProductCatalog < ActiveRecord::Migration
  def change
    remove_column :product_catalogs, :cost, :float
  end
end
