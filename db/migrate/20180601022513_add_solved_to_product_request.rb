class AddSolvedToProductRequest < ActiveRecord::Migration
  def change
    add_column :product_requests, :solved, :boolean, default: false
  end
end
