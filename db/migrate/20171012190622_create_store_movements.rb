class CreateStoreMovements < ActiveRecord::Migration
  def change
    create_table :store_movements do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.string :movement_type
      t.references :order, index: true, foreign_key: true
      t.references :ticket, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.float :initial_price
      t.float :automatic_discount
      t.float :manual_discount
      t.float :discount_applied
      t.boolean :rule_could_be
      t.float :final_price
      t.float :amount
      t.references :return_ticket, index: true, foreign_key: true
      t.references :change_ticket, index: true, foreign_key: true
      t.references :tax, index: true, foreign_key: true
      t.float :taxes
      t.float :cost
      t.references :supplier, index: true, foreign_key: true
      t.references :product_request, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
