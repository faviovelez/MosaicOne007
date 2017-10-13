class AddOneBalanceToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :balance, :float
    add_column :cash_registers, :cash_number, :integer
  end
end
