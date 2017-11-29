class AddCancelReceiptToBill < ActiveRecord::Migration
  def change
    add_column :bills, :cancel_receipt, :string
  end
end
