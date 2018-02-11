class AddReasonToStoreMovements < ActiveRecord::Migration
  def change
    add_column :store_movements, :reason, :text
  end
end
