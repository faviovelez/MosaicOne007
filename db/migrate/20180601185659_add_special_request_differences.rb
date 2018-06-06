class AddSpecialRequestDifferences < ActiveRecord::Migration
  def change
    add_column :product_requests, :special_shortage, :integer
    add_column :product_requests, :special_excess, :integer
  end
end
