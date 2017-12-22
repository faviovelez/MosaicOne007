class AddPosWebIdsToStoreMovement < ActiveRecord::Migration
  def change
    add_column :store_movements, :pos_id, :integer
    add_column :store_movements, :web_id, :integer
  end
end
