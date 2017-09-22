class AddMoreToPaymentForm < ActiveRecord::Migration
  def change
    add_column :payment_forms, :payment_id, :string
  end
end
