class AddLastPurchaseToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :last_purchase_bill_date, :date
  end
end
