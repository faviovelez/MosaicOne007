class DropAssignedTo < ActiveRecord::Migration
  def change
    drop_table :assigned_tos
  end
end
