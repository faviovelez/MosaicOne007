class AddPosAndWebToWithdrawals < ActiveRecord::Migration
  def change
    add_column :withdrawals, :pos_id, :integer
    add_column :withdrawals, :web_id, :integer
    add_column :withdrawals, :pos, :boolean, default: false
    add_column :withdrawals, :web, :boolean, default: false
  end
end
