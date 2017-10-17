class DropProductsTickets < ActiveRecord::Migration
  def change
    drop_table :products_tickets
  end
end
