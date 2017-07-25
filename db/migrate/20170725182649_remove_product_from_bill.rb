class RemoveProductFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :product, index: true, foreign_key: true
  end
end
