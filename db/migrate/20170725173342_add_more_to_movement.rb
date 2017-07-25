class AddMoreToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :business_unit, index: true, foreign_key: true
    add_reference :movements, :prospect, index: true, foreign_key: true
    add_reference :movements, :bill, index: true, foreign_key: true
  end
end
