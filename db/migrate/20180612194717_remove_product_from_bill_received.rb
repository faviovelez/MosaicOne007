class RemoveProductFromBillReceived < ActiveRecord::Migration
  def change
    remove_reference :bill_receiveds, :product, index: true, foreign_key: true
  end
end
