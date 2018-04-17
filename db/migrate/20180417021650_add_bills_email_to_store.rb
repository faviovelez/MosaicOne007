class AddBillsEmailToStore < ActiveRecord::Migration
  def change
    add_column :stores, :bill_email, :string
  end
end
