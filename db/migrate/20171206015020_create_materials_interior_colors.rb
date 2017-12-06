class CreateMaterialsInteriorColors < ActiveRecord::Migration
  def change
    create_table :materials_interior_colors do |t|
      t.references :material, index: true, foreign_key: true
      t.references :interior_color, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
