class AddTotalSubtotalToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :total, :float
    add_column :payments, :subtotal, :float
    add_column :payments, :taxes, :float
  end
end
