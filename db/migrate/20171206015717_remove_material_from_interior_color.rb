class RemoveMaterialFromInteriorColor < ActiveRecord::Migration
  def change
    remove_reference :interior_colors, :material, index: true, foreign_key: true
  end
end
