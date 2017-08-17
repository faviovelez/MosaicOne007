class RemoveBusinessUnitsSupplierTable < ActiveRecord::Migration
  def change
    if table exists? :business_units_suppliers
      drop_table :business_units_suppliers
    end
  end
end
