class AddCfdiToProduct < ActiveRecord::Migration
  def change
    add_column :products, :unit, :string
    add_column :products, :sat_key, :integer
    add_column :products, :unit_key, :string
  end
end
