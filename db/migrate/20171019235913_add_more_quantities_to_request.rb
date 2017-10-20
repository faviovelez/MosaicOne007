class AddMoreQuantitiesToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :second_quantity, :integer
    add_column :requests, :third_quantity, :integer
    add_column :requests, :second_internal_cost, :float
    add_column :requests, :third_internal_cost, :float
    add_column :requests, :second_internal_price, :float
    add_column :requests, :third_internal_price, :float
    add_column :requests, :second_sales_price, :float
    add_column :requests, :third_sales_price, :float
    add_column :requests, :price_selected, :integer
  end
end
