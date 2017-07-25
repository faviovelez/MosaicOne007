class AddOrderToCarrier < ActiveRecord::Migration
  def change
    add_reference :carriers, :order, index: true, foreign_key: true
  end
end
