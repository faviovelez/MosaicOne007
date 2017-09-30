class RemoveProductFromDiscountRules < ActiveRecord::Migration
  def change
    remove_reference :discount_rules, :product, index: true, foreign_key: true
    add_column :discount_rules, :product_gift, :string, array: true, default: []
  end
end
