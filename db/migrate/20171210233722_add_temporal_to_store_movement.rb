class AddTemporalToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :temporal, :boolean
    add_column :store_movements, :down_applied, :boolean
  end
end
