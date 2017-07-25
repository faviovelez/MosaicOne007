class AddMovementToWarehousesEntry < ActiveRecord::Migration
  def change
    add_reference :warehouse_entries, :movement, index: true, foreign_key: true
  end
end
