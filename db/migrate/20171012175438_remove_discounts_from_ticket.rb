class RemoveDiscountsFromTicket < ActiveRecord::Migration
  def change
    remove_column :tickets, :automatic_discount, :float
    remove_column :tickets, :manual_discount, :float
    remove_column :tickets, :total_discount, :float
  end
end
