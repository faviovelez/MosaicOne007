class AddTotalCostToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :total_cost, :float
  end
end
