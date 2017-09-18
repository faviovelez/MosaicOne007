class CreateDiscountRules < ActiveRecord::Migration
  def change
    create_table :discount_rules do |t|
      t.float :percentage
      t.text :product_list, array: true, default: []
      t.text :prospect_list, array: true, default: []
      t.references :product, index: true, foreign_key: true
      t.date :initial_date
      t.date :final_date
      t.references :business_unit, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :rule
      t.float :minimum_amount
      t.integer :minimum_quantity
      t.string :exclusions
      t.boolean :active

      t.timestamps null: false
    end
  end
end
