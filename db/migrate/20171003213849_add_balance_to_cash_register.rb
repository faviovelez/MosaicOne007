class AddBalanceToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :initial_balance, :float
    add_column :cash_registers, :final_balance, :float
  end
end
