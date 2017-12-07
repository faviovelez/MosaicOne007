class CreateMaterialChildren < ActiveRecord::Migration
  def change
    create_table :material_children do |t|
      t.string :name
      t.references :material, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
