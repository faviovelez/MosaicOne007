class AddDiscountToBusinessGroupSale < ActiveRecord::Migration
  def change
    add_column :business_group_sales, :discount, :float
  end
end
