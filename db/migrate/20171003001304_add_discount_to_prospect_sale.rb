class AddDiscountToProspectSale < ActiveRecord::Migration
  def change
    add_column :prospect_sales, :discount, :float
  end
end
