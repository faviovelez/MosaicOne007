class ChangeColumnsFromStoreSale < ActiveRecord::Migration
  def change
    change_column :store_sales, :month, :string
    change_column :store_sales, :year, :string
  end
end
