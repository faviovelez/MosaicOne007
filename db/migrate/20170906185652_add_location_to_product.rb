class AddLocationToProduct < ActiveRecord::Migration
  def change
    add_column :products, :rack, :string
    add_column :products, :level, :string
  end
end
