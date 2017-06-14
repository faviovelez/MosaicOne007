class RemoveMaterialsFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :main_material_color, :string
    remove_column :requests, :secondary_material_color, :string
    remove_column :requests, :third_material_color, :string
  end
end
