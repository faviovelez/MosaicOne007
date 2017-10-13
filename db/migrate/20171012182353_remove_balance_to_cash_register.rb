class RemoveBalanceToCashRegister < ActiveRecord::Migration
  def change
    remove_column :cash_registers, :credit_card_balance, :float
    remove_column :cash_registers, :debit_card_balance, :float
    remove_column :cash_registers, :check_balance, :float
    remove_column :cash_registers, :cash_balance, :float
    remove_column :cash_registers, :other_payment_forms_balance, :float
  end
end
