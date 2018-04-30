class AddKgToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :kg, :float
  end
end
