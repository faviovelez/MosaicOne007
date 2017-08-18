class AddCostToStore < ActiveRecord::Migration
  def change
    add_column :stores, :cost_type_selected_since, :date
  end
end
