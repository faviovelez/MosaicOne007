class AddCreditDaysToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :credit_days, :integer
  end
end
