class AddTicketToPendingMovement < ActiveRecord::Migration
  def change
    add_reference :pending_movements, :ticket, index: true, foreign_key: true
  end
end
