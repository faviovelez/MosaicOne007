class AddParentToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :parent, index: true
  end
end
