class ChangeMinimumFromDiscountRule < ActiveRecord::Migration
  def change
    change_column :discount_rules, :minimum_quantity, :integer, default: 0
    change_column :discount_rules, :minimum_amount, :float, default: 0.0
  end
end
