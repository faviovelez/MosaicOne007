class AddPosWebIdsToTicketsChild < ActiveRecord::Migration
  def change
    add_column :tickets_children, :pos_id, :integer
    add_column :tickets_children, :web_id, :integer
  end
end
