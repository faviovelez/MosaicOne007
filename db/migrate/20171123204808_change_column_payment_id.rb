class ChangeColumnPaymentId < ActiveRecord::Migration
  def change
    rename_column :payment_forms, :payment_id, :payment_key
  end
end
