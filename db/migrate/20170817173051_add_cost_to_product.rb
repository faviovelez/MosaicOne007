class AddCostToProduct < ActiveRecord::Migration
  def change
    add_column :products, :cost, :float
  end
end
