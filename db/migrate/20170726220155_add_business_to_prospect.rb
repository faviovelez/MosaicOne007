class AddBusinessToProspect < ActiveRecord::Migration
  def change
    add_reference :prospects, :business_unit, index: true, foreign_key: true
  end
end
