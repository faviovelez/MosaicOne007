class AddFewToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :discount_applied, :float
    add_column :movements, :final_price, :float
  end
end
