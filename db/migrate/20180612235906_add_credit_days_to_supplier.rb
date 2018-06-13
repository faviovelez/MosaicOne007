class AddCreditDaysToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :credit_days, :integer, default: 0
  end
end
