class AddBusinessUnitToWarehouse < ActiveRecord::Migration
  def change
    add_reference :warehouses, :business_unit, index: true, foreign_key: true
  end
end
