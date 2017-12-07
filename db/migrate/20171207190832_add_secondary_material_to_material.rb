class AddSecondaryMaterialToMaterial < ActiveRecord::Migration
  def change
    add_reference :materials, :parent, index: true
    add_reference :materials, :children, index: true
  end
end
