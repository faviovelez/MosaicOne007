class AddSomeBalancesToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :credit_card_balance, :float
    add_column :cash_registers, :debit_card_balance, :float
    add_column :cash_registers, :check_balance, :float
    add_column :cash_registers, :cash_balance, :float
    add_column :cash_registers, :other_payment_forms_balance, :float
  end
end
