class CreateMaterialsExteriorColors < ActiveRecord::Migration
  def change
    create_table :materials_exterior_colors do |t|
      t.references :material, index: true, foreign_key: true
      t.references :exterior_color, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
