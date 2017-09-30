class AddMoreFiltersToDiscountRule < ActiveRecord::Migration
  def change
    add_column :discount_rules, :line_filter, :text, array: true, default: []
    add_column :discount_rules, :material_filter, :text, array: true, default: []
  end
end
