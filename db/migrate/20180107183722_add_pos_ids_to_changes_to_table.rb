class AddPosIdsToChangesToTable < ActiveRecord::Migration
  def change
    add_column :changes_to_tables, :pos_ids, :text, array: true, default: []
  end
end
