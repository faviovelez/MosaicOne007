class RemoveOrderFromRequest < ActiveRecord::Migration
  def change
    remove_reference :requests, :order, index: true, foreign_key: true
  end
end
