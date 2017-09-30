class RemoveDiscountFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :discount, :float
  end
end
