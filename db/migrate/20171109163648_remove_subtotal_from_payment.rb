class RemoveSubtotalFromPayment < ActiveRecord::Migration
  def change
    remove_column :payments, :subtotal, :float
    remove_column :payments, :taxes, :float
  end
end
