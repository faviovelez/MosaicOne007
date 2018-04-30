class AddAlertToProductRequest < ActiveRecord::Migration
  def change
    add_column :product_requests, :alert, :string
  end
end
