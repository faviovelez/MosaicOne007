class RemoveOrderFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :order, index: true, foreign_key: true
  end
end
