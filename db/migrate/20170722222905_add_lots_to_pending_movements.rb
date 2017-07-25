class AddLotsToPendingMovements < ActiveRecord::Migration
  def change
    add_column :pending_movements, :cost, :float
    add_column :pending_movements, :unique_code, :string
    add_reference :pending_movements, :store, index: true, foreign_key: true
    add_column :pending_movements, :price, :float
    add_reference :pending_movements, :supplier, index: true, foreign_key: true
    add_column :pending_movements, :movement_type, :string
    add_reference :pending_movements, :user, index: true, foreign_key: true
  end
end
