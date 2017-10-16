class RemovePaymentFromTicket < ActiveRecord::Migration
  def change
    remove_reference :tickets, :payment, index: true, foreign_key: true
  end
end
