class AddWarehouseToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :warehouse, index: true, foreign_key: true
  end
end
