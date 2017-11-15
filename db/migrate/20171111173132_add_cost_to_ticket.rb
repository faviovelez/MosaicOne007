class AddCostToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :cost, :float
  end
end
