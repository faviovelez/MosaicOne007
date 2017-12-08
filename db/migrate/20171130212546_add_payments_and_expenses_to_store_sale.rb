class AddPaymentsAndExpensesToStoreSale < ActiveRecord::Migration
  def change
    add_column :store_sales, :payments, :float
    add_column :store_sales, :expenses, :float
  end
end
