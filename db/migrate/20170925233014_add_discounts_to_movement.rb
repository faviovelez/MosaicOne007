class AddDiscountsToMovement < ActiveRecord::Migration
  def change
    add_column :movements, :automatic_discount, :float
    add_column :movements, :manual_discount, :float
    add_reference :movements, :discount_rule, index: true, foreign_key: true
  end
end
