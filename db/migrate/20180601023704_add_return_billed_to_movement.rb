class AddReturnBilledToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :return_billed, :boolean, default: false
  end
end
