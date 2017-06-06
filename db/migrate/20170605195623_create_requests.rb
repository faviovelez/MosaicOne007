class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :product_type
      t.string :product_what
      t.float :product_length
      t.float :product_width
      t.float :product_height
      t.float :product_weight
      t.string :for_what
      t.integer :boxes_stow
      t.integer :quantity
      t.float :inner_length
      t.float :inner_width
      t.string :inner_height
      t.float :outer_length
      t.float :outer_widht
      t.float :outer_height
      t.float :bag_length
      t.float :bag_width
      t.float :bag_height
      t.float :sheet_length
      t.float :sheet_height
      t.string :main_material
      t.string :resistance_main_material
      t.string :secondary_material
      t.string :resistance_secondary_material
      t.string :third_material
      t.string :resistance_third_material
      t.string :impression
      t.integer :inks
      t.string :impression_finishing
      t.string :which_finishing
      t.date :delivery_date
      t.float :maximum_sales_price
      t.text :observations
      t.text :notes
      t.references :prospect, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
