class RemoveTimesFromMovements < ActiveRecord::Migration
  def change
    remove_column :movements, :times_ordered, :integer
  end
end
