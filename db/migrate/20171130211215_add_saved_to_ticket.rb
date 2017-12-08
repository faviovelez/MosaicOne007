class AddSavedToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :saved, :boolean
  end
end
