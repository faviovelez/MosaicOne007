class RemoveBusinessUnitFromStoreType < ActiveRecord::Migration
  def change
    remove_reference :store_types, :business_unit, index: true, foreign_key: true
  end
end
