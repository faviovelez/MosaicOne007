class CreateExhibitionInventories < ActiveRecord::Migration
  def change
    create_table :exhibition_inventories do |t|
      t.references :store, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
