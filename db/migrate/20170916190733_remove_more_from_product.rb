class RemoveMoreFromProduct < ActiveRecord::Migration
  def change
    remove_column :products, :unit, :string
    remove_column :products, :sat_key, :integer
    remove_column :products, :unit_key, :string
  end
end
