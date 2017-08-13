class AddBusinessGroupToWarehouse < ActiveRecord::Migration
  def change
    add_reference :warehouses, :business_group, index: true, foreign_key: true
  end
end
