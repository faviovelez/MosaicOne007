class AddTotalSubtotalToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :total, :float
    add_column :movements, :subtotal, :float
  end
end
