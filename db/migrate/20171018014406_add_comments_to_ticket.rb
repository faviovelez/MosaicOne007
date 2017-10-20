class AddCommentsToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :comments, :string
  end
end
