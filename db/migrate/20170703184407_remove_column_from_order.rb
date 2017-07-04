class RemoveColumnFromOrder < ActiveRecord::Migration
  def change
    remove_reference :orders, :product_catalog, index: true, foreign_key: true
  end
end
