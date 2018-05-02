class ChangeStoreSaleCost < ActiveRecord::Migration
  def change
    change_column :store_sales, :cost, :float, default: 0.0
  end
end
