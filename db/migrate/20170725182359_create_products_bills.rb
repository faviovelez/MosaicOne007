class CreateProductsBills < ActiveRecord::Migration
  def change
    create_table :products_bills do |t|
      t.references :product, index: true, foreign_key: true
      t.references :bill, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
