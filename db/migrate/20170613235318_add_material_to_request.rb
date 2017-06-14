class AddMaterialToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :exterior_material_color, :string
    add_column :requests, :interior_material_color, :string
    add_column :requests, :other_material_color, :string
  end
end
