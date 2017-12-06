class RemoveMaterialFromExteriorColor < ActiveRecord::Migration
  def change
    remove_reference :exterior_colors, :material, index: true, foreign_key: true
  end
end
