class AddBankToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :bank, index: true, foreign_key: true
  end
end
