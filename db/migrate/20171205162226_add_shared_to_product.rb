class AddSharedToProduct < ActiveRecord::Migration
  def change
    add_column :products, :shared, :boolean
  end
end
