class ChangePriceFromPendingMovements < ActiveRecord::Migration
  def change
    rename_column :pending_movements, :price, :initial_price
  end
end
