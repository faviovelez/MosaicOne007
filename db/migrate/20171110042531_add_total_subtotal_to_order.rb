class AddTotalSubtotalToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :total, :float
    add_column :orders, :subtotal, :float
    add_column :orders, :taxes, :float
    add_column :orders, :discount_applied, :float
  end
end
