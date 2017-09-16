class AddCorrectUnitsToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :unit, index: true, foreign_key: true
    add_reference :products, :sat_key, index: true, foreign_key: true
    add_reference :products, :sat_unit_key, index: true, foreign_key: true
  end
end
