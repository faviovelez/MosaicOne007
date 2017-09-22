class AddMoreToTax < ActiveRecord::Migration
  def change
    add_column :taxes, :key, :string
    add_column :taxes, :transfer, :boolean
    add_column :taxes, :retention, :boolean
  end
end
