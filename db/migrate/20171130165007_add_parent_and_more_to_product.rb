class AddParentAndMoreToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :child, index: true
    add_reference :products, :parent, index: true
  end
end
