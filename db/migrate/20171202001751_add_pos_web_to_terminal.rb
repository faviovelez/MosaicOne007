class AddPosWebToTerminal < ActiveRecord::Migration
  def change
    add_column :terminals, :pos, :boolean, default: false
    add_column :terminals, :web, :boolean, default: false
    add_column :terminals, :date, :date
  end
end
