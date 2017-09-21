class RemoveBusinessUnitFromDiscountRule < ActiveRecord::Migration
  def change
    remove_reference :discount_rules, :business_unit, index: true, foreign_key: true
    remove_reference :discount_rules, :store, index: true, foreign_key: true

  end
end
