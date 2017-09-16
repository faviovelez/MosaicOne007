class CreateInteriorColors < ActiveRecord::Migration
  def change
    create_table :interior_colors do |t|
      t.string :name
      t.references :material, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
