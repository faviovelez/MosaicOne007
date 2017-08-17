class RemoveBusinessUnitsSupplierTable < ActiveRecord::Migration
  def change
    drop_table :business_units_suppliers
  end
end
