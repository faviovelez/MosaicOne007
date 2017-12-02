class AddPosWebToTicketsChildren < ActiveRecord::Migration
  def change
    add_column :tickets_children, :pos, :boolean, default: false
    add_column :tickets_children, :web, :boolean, default: false
    add_column :tickets_children, :date, :date
  end
end
