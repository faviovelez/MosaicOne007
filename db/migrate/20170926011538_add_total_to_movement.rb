class AddTotalToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :amount, :float
  end
end
