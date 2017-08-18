class AddCostTypeToStore < ActiveRecord::Migration
  def change
    add_reference :stores, :cost_type, index: true, foreign_key: true
  end
end
