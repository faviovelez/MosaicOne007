class AddUnitIdToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :unit, index: true, foreign_key: true
  end
end
