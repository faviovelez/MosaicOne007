class AddArmedToProductRequest < ActiveRecord::Migration
  def change
    add_column :product_requests, :armed, :boolean
  end
end
