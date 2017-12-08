class AddPosWebToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :pos, :boolean, default: false
    add_column :cash_registers, :web, :boolean, default: false
    add_column :cash_registers, :date, :date
  end
end
