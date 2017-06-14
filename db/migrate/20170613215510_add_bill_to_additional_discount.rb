class AddBillToAdditionalDiscount < ActiveRecord::Migration
  def change
    add_reference :additional_discounts, :bill, index: true, foreign_key: true
  end
end
