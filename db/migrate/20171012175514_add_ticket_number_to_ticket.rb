class AddTicketNumberToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :ticket_number, :integer
  end
end
