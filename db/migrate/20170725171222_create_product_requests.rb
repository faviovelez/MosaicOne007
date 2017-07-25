class CreateProductRequests < ActiveRecord::Migration
  def change
    create_table :product_requests do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.string :status
      t.references :order, index: true, foreign_key: true
      t.string :urgency_level
      t.date :maximum_date

      t.timestamps null: false
    end
  end
end
