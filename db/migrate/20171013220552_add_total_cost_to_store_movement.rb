class AddTotalCostToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :total_cost, :float
  end
end
