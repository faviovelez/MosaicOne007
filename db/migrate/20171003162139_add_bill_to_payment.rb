class AddBillToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :bill, index: true, foreign_key: true
  end
end
