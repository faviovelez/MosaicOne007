class AddDifferencesToProductRequest < ActiveRecord::Migration
  def change
    add_column :product_requests, :surplus, :integer
    add_column :product_requests, :excess, :integer
  end
end
