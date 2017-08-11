class AddCodeToWarehouse < ActiveRecord::Migration
  def change
    add_column :warehouses, :warehouse_code, :string
  end
end
