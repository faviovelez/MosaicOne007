class AddMoreToPaymentMethod < ActiveRecord::Migration
  def change
    add_column :payment_methods, :method, :string
  end
end
