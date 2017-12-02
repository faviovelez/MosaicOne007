class AddBillToStoreMovement < ActiveRecord::Migration
  def change
    add_reference :store_movements, :bill, index: true, foreign_key: true
  end
end
