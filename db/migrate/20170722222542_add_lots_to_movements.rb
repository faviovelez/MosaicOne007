class AddLotsToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :cost, :float
    add_column :movements, :unique_code, :string
    add_reference :movements, :store, index: true, foreign_key: true
    add_column :movements, :price, :float
    add_reference :movements, :supplier, index: true, foreign_key: true
  end
end
