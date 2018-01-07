class RemovePosIdFromChangesToTable < ActiveRecord::Migration
  def change
    remove_column :changes_to_tables, :pos_id, :text, default: []
    add_column :changes_to_tables, :pos_id, :integer
  end
end
