class ChangeStoreSaleDefault < ActiveRecord::Migration
  def change
    change_column :store_sales, :discount, :float, default: 0
    change_column :store_sales, :total, :float, default: 0
    change_column :store_sales, :subtotal, :float, default: 0
    change_column :store_sales, :taxes, :float, default: 0
    change_column :store_sales, :quantity, :float, default: 0
    change_column :store_sales, :payments, :float, default: 0
    change_column :store_sales, :expenses, :float, default: 0
  end
end
