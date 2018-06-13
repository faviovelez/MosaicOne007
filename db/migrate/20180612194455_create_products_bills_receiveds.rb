class CreateProductsBillsReceiveds < ActiveRecord::Migration
  def change
    create_table :products_bills_receiveds do |t|
      t.references :bill_received, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
