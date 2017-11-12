class AddPayedToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :payed, :boolean, default: false
  end
end
