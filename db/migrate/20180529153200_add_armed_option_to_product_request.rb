class AddArmedOptionToProductRequest < ActiveRecord::Migration
  def change
    change_column :product_requests, :armed, :boolean, default: false
  end
end
