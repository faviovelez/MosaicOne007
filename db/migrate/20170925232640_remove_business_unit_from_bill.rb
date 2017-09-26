class RemoveBusinessUnitFromBill < ActiveRecord::Migration
  def change
    remove_reference :bills, :business_unit, index: true, foreign_key: true
  end
end
