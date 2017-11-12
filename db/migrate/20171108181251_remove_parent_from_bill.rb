class RemoveParentFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :parent, index: true
    remove_reference :bills, :child_bills, index: true
  end
end
