class RemoveOrderFromCarrier < ActiveRecord::Migration
  def change
    remove_reference :carriers, :order, index: true, foreign_key: true
  end
end
