class RemoveDiscountFromOrder < ActiveRecord::Migration
  def change
    remove_reference :orders, :additional_discount, index: true, foreign_key: true
  end
end
