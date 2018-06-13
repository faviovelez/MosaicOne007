class AddDiscountToBillReceived < ActiveRecord::Migration
  def change
    add_column :bill_receiveds, :discount, :float
    add_column :bill_receiveds, :subtotal_with_discount, :float
  end
end
