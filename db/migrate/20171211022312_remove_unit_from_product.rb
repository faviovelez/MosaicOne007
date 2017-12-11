class RemoveUnitFromProduct < ActiveRecord::Migration
  def change
    remove_reference :products, :unit, index: true, foreign_key: true
  end
end
