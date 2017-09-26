class RemoveAdditionalDiscountFromBill < ActiveRecord::Migration
  def change
    remove_column :bills, :additional_discount_applied, :float
    add_column :bills, :automatic_discount_applied, :float
    add_column :bills, :manual_discount_applied, :float
  end
end
