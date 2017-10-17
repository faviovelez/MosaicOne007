class DropAdditionalDiscounts < ActiveRecord::Migration
  def change
    drop_table :additional_discounts
  end
end
