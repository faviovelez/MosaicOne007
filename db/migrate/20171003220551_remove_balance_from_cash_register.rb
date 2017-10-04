class RemoveBalanceFromCashRegister < ActiveRecord::Migration
  def change
    remove_column :cash_registers, :initial_balance, :float
    remove_column :cash_registers, :final_balance, :float
  end
end
