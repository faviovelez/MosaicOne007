class AddFilesToBill < ActiveRecord::Migration
  def change
    add_column :bills, :pdf, :string
    add_column :bills, :xml, :string
  end
end
