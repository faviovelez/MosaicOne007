class AddCashAlertToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :cash_alert, :float, default: 0
  end
end
