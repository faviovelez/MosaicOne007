class AddBillTypeToBill < ActiveRecord::Migration
  def change
    add_column :bills, :bill_type, :string
  end
end
