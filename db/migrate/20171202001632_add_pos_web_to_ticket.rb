class AddPosWebToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :pos, :boolean, default: false
    add_column :tickets, :web, :boolean, default: false
    add_column :tickets, :date, :date
  end
end
