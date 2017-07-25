class AddBusinessToStore < ActiveRecord::Migration
  def change
    add_reference :stores, :business_unit, index: true, foreign_key: true
  end
end
