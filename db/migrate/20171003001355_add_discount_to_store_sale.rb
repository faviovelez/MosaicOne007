class AddDiscountToStoreSale < ActiveRecord::Migration
  def change
    add_column :store_sales, :discount, :float
  end
end
