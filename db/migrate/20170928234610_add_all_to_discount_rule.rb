class AddAllToDiscountRule < ActiveRecord::Migration
  def change
    add_column :discount_rules, :product_all, :boolean
    add_column :discount_rules, :prospect_all, :boolean
  end
end
