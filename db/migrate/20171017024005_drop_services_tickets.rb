class DropServicesTickets < ActiveRecord::Migration
  def change
    drop_table :services_tickets
  end
end
