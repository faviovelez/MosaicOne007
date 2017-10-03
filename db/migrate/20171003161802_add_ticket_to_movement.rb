class AddTicketToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :ticket, index: true, foreign_key: true
  end
end
