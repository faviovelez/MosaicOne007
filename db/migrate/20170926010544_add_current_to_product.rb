class AddCurrentToProduct < ActiveRecord::Migration
  def change
    add_column :products, :current, :boolean
  end
end
