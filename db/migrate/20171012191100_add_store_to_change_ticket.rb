class AddStoreToChangeTicket < ActiveRecord::Migration
  def change
    add_reference :change_tickets, :store, index: true, foreign_key: true
  end
end
