class AddBillToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :bill, index: true, foreign_key: true
  end
end
