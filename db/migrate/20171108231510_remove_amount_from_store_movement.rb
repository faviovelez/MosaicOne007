class RemoveAmountFromStoreMovement < ActiveRecord::Migration
  def change
    remove_column :store_movements, :amount, :float
  end
end
