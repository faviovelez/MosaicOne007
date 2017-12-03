class AddPosWebToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :pos, :boolean, default: false
    add_column :store_movements, :web, :boolean, default: true
    add_column :store_movements, :date, :date
  end
end
