class AddFieldsToBill < ActiveRecord::Migration
  def change
    add_column :bills, :type_of_bill, :string
    add_reference :bills, :prospect, index: true, foreign_key: true
    add_column :bills, :classification, :string
  end
end
