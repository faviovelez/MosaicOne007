class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :product, index: true, foreign_key: true
      t.string :quantity

      t.timestamps null: false
    end
  end
end
