class AddPaymentConditionsToPreferredBillOptions < ActiveRecord::Migration
  def change
    add_column :preferred_bill_options, :payment_condition, :string
  end
end
