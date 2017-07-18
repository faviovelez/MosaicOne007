class AddMoreToProduct < ActiveRecord::Migration
  def change
    add_column :products, :classification, :string
    add_column :products, :line, :string
  end
end
