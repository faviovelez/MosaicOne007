class AddBusinessToBusinessUnit < ActiveRecord::Migration
  def change
    add_reference :business_units, :business_group, index: true, foreign_key: true
  end
end
