class AddPosWebIdsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :pos_id, :integer
    add_column :tickets, :web_id, :integer
  end
end
