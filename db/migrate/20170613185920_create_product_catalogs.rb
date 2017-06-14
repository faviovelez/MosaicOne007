class CreateProductCatalogs < ActiveRecord::Migration
  def change
    create_table :product_catalogs do |t|
      t.string :former_code
      t.string :unique_code
      t.string :description
      t.string :product_type
      t.string :exterior_material_color
      t.string :interior_material_color
      t.boolean :impression
      t.string :exterior_color_or_design
      t.string :main_material
      t.string :resistance_main_material
      t.float :inner_length
      t.float :inner_width
      t.float :inner_height
      t.float :outer_length
      t.float :outer_width
      t.float :outer_height
      t.string :design_type
      t.integer :number_of_pieces
      t.string :accesories_kit
      t.float :cost

      t.timestamps null: false
    end
  end
end
