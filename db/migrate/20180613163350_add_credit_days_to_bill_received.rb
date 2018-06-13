class AddCreditDaysToBillReceived < ActiveRecord::Migration
  def change
    add_column :bill_receiveds, :credit_days, :integer, default: 0
  end
end
