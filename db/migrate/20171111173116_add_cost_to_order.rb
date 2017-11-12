class AddCostToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :cost, :float
  end
end
