class RemoveTypeFromPendingMovements < ActiveRecord::Migration
  def change
    remove_column :pending_movements, :movement_type, :string
  end
end
