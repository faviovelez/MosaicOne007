class AddStoreToReturnTicket < ActiveRecord::Migration
  def change
    add_reference :return_tickets, :store, index: true, foreign_key: true
  end
end
