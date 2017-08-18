class RemoveSelectedFromCostType < ActiveRecord::Migration
  def change
    remove_column :cost_types, :selected, :boolean
  end
end
