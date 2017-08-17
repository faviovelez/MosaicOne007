class RemoveBusinessUnitsSupplierTable < ActiveRecord::Migration
  def change
<<<<<<< 195b2bdd9a4f72323a76cea1a9f8f11b4c244aaa
    if table exists? :business_units_suppliers
      drop_table :business_units_suppliers
    end
=======
    drop_table :business_units_suppliers
>>>>>>> added suppliers and configuration, modified navs
  end
end
