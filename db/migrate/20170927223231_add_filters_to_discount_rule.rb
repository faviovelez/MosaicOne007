class AddFiltersToDiscountRule < ActiveRecord::Migration
  def change
    add_column :discount_rules, :prospect_filter, :string
    add_column :discount_rules, :product_filter, :string
  end
end
