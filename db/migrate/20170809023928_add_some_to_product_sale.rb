class AddSomeToProductSale < ActiveRecord::Migration
  def change
    remove_column :product_sales, :month, :string
    remove_column :product_sales, :year, :string
    add_column :product_sales, :month, :integer
    add_column :product_sales, :year, :integer

  end
end
