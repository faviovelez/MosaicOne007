class AddCashRegisterToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :cash_register, index: true, foreign_key: true
  end
end
