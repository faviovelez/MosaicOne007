class RemovePaymentConditionFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :payment_condition, index: true, foreign_key: true
    add_column :bills, :payment_conditions, :string
  end
end
