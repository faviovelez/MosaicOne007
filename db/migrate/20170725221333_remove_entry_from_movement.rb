class RemoveEntryFromMovement < ActiveRecord::Migration
  def change
    remove_column :movements, :entry_movement, :integer
  end
end
