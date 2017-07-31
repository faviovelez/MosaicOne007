class AddDeliveryToPendingMovement < ActiveRecord::Migration
  def change
    add_column :pending_movements, :maximum_date, :date
  end
end
