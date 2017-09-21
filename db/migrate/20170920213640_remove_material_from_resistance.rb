class RemoveMaterialFromResistance < ActiveRecord::Migration
  def change
    remove_reference :resistances, :material, index: true, foreign_key: true
  end
end
