class RemovePosIdIntegerFromChangesToTable < ActiveRecord::Migration
  def change
    remove_column :changes_to_tables, :pos_id, :integer
  end
end
