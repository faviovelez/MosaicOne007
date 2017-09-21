class AddDoubleToDiscountRule < ActiveRecord::Migration
  def change
    add_reference :discount_rules, :bu_buyer, index: true
    add_reference :discount_rules, :bu_seller, index: true
    add_reference :discount_rules, :store_buyer, index: true
    add_reference :discount_rules, :store_seller, index: true
  end
end
