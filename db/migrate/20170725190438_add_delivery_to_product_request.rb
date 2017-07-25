class AddDeliveryToProductRequest < ActiveRecord::Migration
  def change
    add_reference :product_requests, :delivery_package, index: true, foreign_key: true
  end
end
