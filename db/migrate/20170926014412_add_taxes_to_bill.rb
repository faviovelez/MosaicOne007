class AddTaxesToBill < ActiveRecord::Migration
  def change
    add_column :bills, :taxes_transferred, :float
    add_column :bills, :taxes_witheld, :float
  end
end
