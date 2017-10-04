class AddCashRegisterToDeposit < ActiveRecord::Migration
  def change
    add_reference :deposits, :cash_register, index: true, foreign_key: true
  end
end
