class AddPosAndWebToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :pos_id, :integer
    add_column :deposits, :web_id, :integer
    add_column :deposits, :pos, :boolean, default: false
    add_column :deposits, :web, :boolean, default: false

  end
end
