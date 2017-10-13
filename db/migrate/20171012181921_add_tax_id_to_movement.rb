class AddTaxIdToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :tax, index: true, foreign_key: true
    add_column :movements, :taxes, :float
  end
end
