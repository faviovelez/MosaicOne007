class AddPaymentBillToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :payment_bill, index: true
  end
end
