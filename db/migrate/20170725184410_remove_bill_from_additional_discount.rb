class RemoveBillFromAdditionalDiscount < ActiveRecord::Migration
  def change
    remove_reference :additional_discounts, :bill, index: true, foreign_key: true
  end
end
