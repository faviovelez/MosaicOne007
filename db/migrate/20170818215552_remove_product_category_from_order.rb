class RemoveProductCategoryFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :product_category, :string
  end
end
