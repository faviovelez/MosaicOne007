class AddPayBillToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :pay_bill, index: true
  end
end
