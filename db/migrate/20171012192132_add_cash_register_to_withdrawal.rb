class AddCashRegisterToWithdrawal < ActiveRecord::Migration
  def change
    add_reference :withdrawals, :cash_register, index: true, foreign_key: true
  end
end
