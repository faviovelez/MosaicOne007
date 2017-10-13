class AddBillToReturnTicket < ActiveRecord::Migration
  def change
    add_reference :return_tickets, :bill, index: true, foreign_key: true
  end
end
