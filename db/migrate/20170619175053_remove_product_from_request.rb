class RemoveProductFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :product_code, :string
  end
end
