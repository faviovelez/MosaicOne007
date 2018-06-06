class ChangePayedFromBill < ActiveRecord::Migration
  def change
    change_column :bills, :payed, :boolean, default: false
  end
end
