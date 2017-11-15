class RemoveReferencesFromStoreMovement < ActiveRecord::Migration
  def change
    remove_reference :store_movements, :change_ticket, index: true, foreign_key: true
    remove_reference :store_movements, :return_ticket, index: true, foreign_key: true
  end
end
