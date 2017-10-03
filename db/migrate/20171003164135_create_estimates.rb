class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :quantity
      t.float :discount
      t.references :estimate_doc, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
