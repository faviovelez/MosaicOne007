class CreateProductsTickets < ActiveRecord::Migration
  def change
    create_table :products_tickets do |t|
      t.references :ticket, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
