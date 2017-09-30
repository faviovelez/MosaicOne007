class AddSupplierToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :supplier, index: true, foreign_key: true
  end
end
