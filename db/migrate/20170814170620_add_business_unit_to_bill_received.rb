class AddBusinessUnitToBillReceived < ActiveRecord::Migration
  def change
    add_reference :bill_receiveds, :business_unit, index: true, foreign_key: true
  end
end
