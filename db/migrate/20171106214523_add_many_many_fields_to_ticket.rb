class AddManyManyFieldsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :payments_amount, :float
    add_column :tickets, :discount_applied, :float
    add_column :tickets, :cash_return, :float
  end
end
