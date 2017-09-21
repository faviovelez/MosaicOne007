class RemoveBuyersFromDiscountRule < ActiveRecord::Migration
  def change
    remove_reference :discount_rules, :bu_buyer, index: true
    remove_reference :discount_rules, :bu_seller, index: true
    remove_reference :discount_rules, :store_buyer, index: true
    remove_reference :discount_rules, :store_seller, index: true
    add_reference :discount_rules, :business_unit, index: true, foreign_key: true
    add_reference :discount_rules, :store, index: true, foreign_key: true
  end
end
