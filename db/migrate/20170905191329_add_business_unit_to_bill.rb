class AddBusinessUnitToBill < ActiveRecord::Migration
  def change
    add_reference :bills, :business_unit, index: true, foreign_key: true
    remove_reference :bills, :store, index: true, foreign_key: true
  end
end
