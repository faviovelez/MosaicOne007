class RemoveBusinessUnitFromServiceOffered < ActiveRecord::Migration
  def change
    remove_reference :service_offereds, :business_unit, index: true, foreign_key: true
  end
end
