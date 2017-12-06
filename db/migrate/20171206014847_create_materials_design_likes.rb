class CreateMaterialsDesignLikes < ActiveRecord::Migration
  def change
    create_table :materials_design_likes do |t|
      t.references :material, index: true, foreign_key: true
      t.references :design_like, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
