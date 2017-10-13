class AddBillToChangeTicket < ActiveRecord::Migration
  def change
    add_reference :change_tickets, :bill, index: true, foreign_key: true
  end
end
