class AddUserToStoreMovements < ActiveRecord::Migration
  def change
    add_reference :store_movements, :user, index: true, foreign_key: true
  end
end
