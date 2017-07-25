class AddEntryToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :entry_movement, :integer
  end
end
