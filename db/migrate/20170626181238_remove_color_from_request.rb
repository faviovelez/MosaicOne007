class RemoveColorFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :other_material_color, :string
  end
end
