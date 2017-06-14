class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :name
      t.string :street
      t.string :exterior_number
      t.string :interior_number
      t.string :zipcode
      t.string :neighborhood
      t.text :additional_references
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
