class AddWebIdToChangesToTable < ActiveRecord::Migration
  def change
    remove_column :changes_to_tables, :web_id, :text, array: true, default: []
    add_column :changes_to_tables, :web_id, :integer
    remove_column :changes_to_tables, :pos_id, :integer
    add_column :changes_to_tables, :pos_id, :text, array: true, default: []
  end
end
