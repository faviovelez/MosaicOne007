class AddKeyToTypeOfBill < ActiveRecord::Migration
  def change
    add_column :type_of_bills, :key, :string
  end
end
