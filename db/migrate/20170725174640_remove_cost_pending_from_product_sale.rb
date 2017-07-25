class RemoveCostPendingFromProductSale < ActiveRecord::Migration
  def change
    remove_column :product_sales, :cost_pending
  end
end
