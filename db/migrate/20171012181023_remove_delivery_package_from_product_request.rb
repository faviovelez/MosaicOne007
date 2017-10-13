class RemoveDeliveryPackageFromProductRequest < ActiveRecord::Migration
  def change
    remove_reference :product_requests, :delivery_package, index: true, foreign_key: true
  end
end
