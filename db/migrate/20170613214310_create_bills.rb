class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :status
      t.references :product_catalog, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.float :initial_price
      t.float :discount_applied
      t.float :additional_discount_applied
      t.float :price_before_taxes

      t.timestamps null: false
    end
  end
end
