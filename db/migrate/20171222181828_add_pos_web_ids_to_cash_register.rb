class AddPosWebIdsToCashRegister < ActiveRecord::Migration
  def change
    add_column :cash_registers, :pos_id, :integer
    add_column :cash_registers, :web_id, :integer
  end
end
