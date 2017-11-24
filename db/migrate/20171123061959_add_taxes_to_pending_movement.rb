class AddTaxesToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :taxes, :float, default: 0
  end
end
