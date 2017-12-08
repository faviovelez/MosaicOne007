class AddProspectToStoreMovement < ActiveRecord::Migration
  def change
    add_reference :store_movements, :prospect, index: true, foreign_key: true
  end
end
