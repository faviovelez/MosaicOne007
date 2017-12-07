class AddChildrenToMaterialChild < ActiveRecord::Migration
  def change
    add_reference :material_children, :children, index: true
  end
end
