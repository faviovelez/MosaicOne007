class RemoveAmountFromMovement < ActiveRecord::Migration
  def change
    remove_column :movements, :amount, :float
  end
end
