class AddTotalCostToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :total_cost, :float
  end
end
